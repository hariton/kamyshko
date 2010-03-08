namespace :gems do

  desc 'install_unbundled_gems'
  task :install_unbundled_gems do
    run("sudo #{bin_dir}/gem install bundler --version 0.9.9 --no-rdoc --no-ri --source=http://rubygems.org")
  end

  desc 'symlink_vendor'
  task :symlink_vendor do
    release_gems = "#{release_path}/vendor/bundler_gems"
    %w(bin cache doc gems specifications).each do |sub_dir|
      shared_sub_dir = "#{shared_path}/vendor/bundler_gems/#{sub_dir}"
      run "mkdir -p #{shared_sub_dir} && mkdir -p #{release_gems} && ln -s #{shared_sub_dir} #{release_gems}/#{sub_dir}"
    end
  end

  desc 'bundle_new_release'
  task :bundle_new_release, :roles => :web, :except => { :no_release => true } do
    gems.symlink_vendor
    #run "cd #{release_path} && bundle unlock"
    run "cd #{release_path} && bundle install vendor/bundler_gems/"
    #run "cd #{release_path} && bundle lock"
  end

end
