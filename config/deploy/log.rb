namespace :log do

  desc 'log:clear'
  task :clear do
    rake 'log:clear'
  end

  desc 'Real-time rails log'
  task :tail do
    stream "tail -f #{shared_path}/log/#{rails_env}.log"
  end

end
