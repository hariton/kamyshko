namespace :deploy do

  desc 'Update the crontab file'
  task :update_crontab, :roles => :app do
    run "cd #{release_path} && bundle exec bin/whenever --update-crontab #{application}"
  end

end
