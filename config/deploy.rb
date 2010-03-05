set :application, 'kamyshko'
set :rails_env, 'production'

ssh_options[:forward_agent] = true
ssh_options[:port] = 1685

set :host, 'popla.zoo.lan'
set :user, 'webapps'
set :deploy_to, "/var/webapps/#{application}"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :use_sudo, false

set :scm, 'git'
set :repository, 'git@github.com:hariton/kamyshko.git'
set :branch, 'master'
set :deploy_via, :remote_cache
# set :git_shallow_clone, true
# set :git_shallow, 1

set :keep_releases, 3

set :bin_dir, '/opt/ruby-enterprise-1.8.7-2009.10/bin'

set :shared_children, shared_children + %w(public/sources public/zip)

role :web, host
role :app, host
role :db,  host, :primary => true

after 'deploy:update_code', 'bundler:bundle_new_release'
after 'deploy:update_code', 'deploy:symlink_shared'

namespace :deploy do

  desc <<-DESC
    Not used with Passenger
  DESC
  task :start do
  end

  desc <<-DESC
    Not used with Passenger
  DESC
  task :stop do
  end

  desc <<-DESC
    restart
  DESC
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp', 'restart.txt')}"
  end

  desc 'Symlink shared configs and folders on each release.'
  task :symlink_shared do
    run "ln -fs #{shared_path}/public/sources #{release_path}/public/sources"
    run "ln -fs #{shared_path}/public/zip #{release_path}/public/zip"
  end

  namespace :web do

    desc 'Serve up a custom maintenance page.'
    task :disable, :roles => :web do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason      = ENV['REASON']
      deadline    = ENV['UNTIL']

      template = File.read('app/views/maintenance/maintenance.html.erb')
      page = ERB.new(template).result(binding)

      put page, "#{shared_path}/system/maintenance.html", :mode => 0644
    end

  end

end

namespace :bundler do

  desc <<-DESC
    symlink_vendor
  DESC
  task :symlink_vendor do
    shared_gems = File.join(shared_path, 'vendor/bundler_gems')
    release_gems = "#{release_path}/vendor/bundler_gems" 
    %w(cache gems specifications).each do |sub_dir|
      shared_sub_dir = File.join(shared_gems, sub_dir)
      run("mkdir -p #{shared_sub_dir} && mkdir -p #{release_gems} && ln -s #{shared_sub_dir} #{release_gems}/#{sub_dir}")
    end
  end

  desc <<-DESC
    bundle_new_release
  DESC
  task :bundle_new_release do
    bundler.symlink_vendor
    # run("cd #{release_path} && ./script/bundle --only #{rails_env}")
    run("cd #{release_path} && ./script/bundle --cached")
  end
end

namespace :passenger do
  desc 'passenger memory stats'
  task :memory, :roles => :app do
    run "sudo #{bin_dir}/passenger-memory-stats" do |channel, stream, data|
      puts data
    end
  end

  desc 'passenger general info'
  task :general, :roles => :app do
    run "sudo #{bin_dir}/passenger-status"
  end
end

desc 'Last items from production log in real-time'
task :tail do
  stream "tail -f #{shared_path}/log/#{rails_env}.log"
end
