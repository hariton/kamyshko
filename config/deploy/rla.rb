namespace :rla do

  desc 'rla:rails'
  task :rails do
    run "cd #{current_path} && bundle exec bin/request-log-analyzer log/#{rails_env}.log"
  end

  desc 'rla:nginx'
  task :nginx do
    run "cd #{current_path} && bundle exec bin/request-log-analyzer /opt/nginx/logs/access.log"
  end

end
