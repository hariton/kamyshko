namespace :deploy do

  desc 'Start Passenger'
  task :start do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc 'Stop Passenger'
  task :stop do
  end

  desc 'Restart Passenger'
  task :restart do
    stop
    start
  end

end

namespace :passenger do

  desc 'Passenger memory stats'
  task :memory, :roles => :app do
    run "sudo #{bin_dir}/passenger-memory-stats" do |channel, stream, data|
      puts data
    end
  end

  desc 'Passenger general info'
  task :general, :roles => :app do
    run "sudo #{bin_dir}/passenger-status"
  end

end
