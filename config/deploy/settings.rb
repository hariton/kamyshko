set :application, 'kamyshko'
set :rails_env, 'production'

set :host, 'popla.zoo.lan'
set :user, 'webapps'
set :deploy_to, "/var/#{user}/#{application}"
set :use_sudo, false

ssh_options[:forward_agent] = true
ssh_options[:port] = 1685
default_run_options[:pty] = true

set :scm, 'git'
set :repository, 'git@github.com:hariton/kamyshko.git'
set :branch, 'master'
set :deploy_via, :remote_cache
# set :git_shallow_clone, true
# set :git_shallow, 1

set :use_sudo, false
set :keep_releases, 5

set :bin_dir, '/opt/ruby-enterprise-1.8.7-2010.01/bin'

role :web, host
role :app, host
role :db,  host, :primary => true

set :shared_children, shared_children + %w(public/sources public/zip db/sphinx)

after 'deploy:setup',           'db:setup' unless fetch(:skip_db_setup, false)
after 'deploy:setup',           'gems:install_unbundled_gems'
after 'deploy:update_code',     'deploy:symlink_shared'
after 'deploy:update_code',     'gems:bundle_new_release'
after 'deploy:update_code',     'thinking_sphinx:configure', 'thinking_sphinx:stop', 'thinking_sphinx:start'
#after 'deploy:update_code',     'deploy:update_crontab'
after 'deploy:update_code',     'sass:update'
after 'deploy:finalize_update', 'db:symlink'

