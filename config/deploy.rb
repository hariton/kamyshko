load 'config/deploy/settings'
load 'config/deploy/gems'
load 'config/deploy/capistrano_database_yml'
load 'config/deploy/symlinks'
load 'config/deploy/passenger'
load 'config/deploy/maintenance'
load 'config/deploy/thinking_sphinx'
load 'config/deploy/crontab'
load 'config/deploy/rla'
load 'config/deploy/log'
load 'config/deploy/db'
load 'config/deploy/sass'

def rake(*tasks)
  rails_env = fetch(:rails_env, 'production')
  rake = fetch(:rake, 'rake')
  tasks.each do |t|
    run "if [ -d #{current_path} ]; then cd #{current_path}; else cd #{release_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
  end
end
