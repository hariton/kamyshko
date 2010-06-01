load 'config/deploy/settings.rb'
load 'config/deploy/gems.rb'
load 'config/deploy/capistrano_database_yml.rb'
load 'config/deploy/symlinks.rb'
load 'config/deploy/passenger.rb'
load 'config/deploy/maintenance.rb'
load 'config/deploy/thinking_sphinx.rb'
load 'config/deploy/crontab.rb'
load 'config/deploy/rla.rb'
load 'config/deploy/log.rb'
load 'config/deploy/db.rb'
load 'config/deploy/sass.rb'

def rake(*tasks)
  rails_env = fetch(:rails_env, 'production')
  rake = fetch(:rake, 'rake')
  tasks.each do |t|
    run "if [ -d #{current_path} ]; then cd #{current_path}; else cd #{release_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
  end
end
