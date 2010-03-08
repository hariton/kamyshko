namespace :db do

  desc 'db:create'
  task :create do
    rake 'db:create'
  end

  desc 'db:drop'
  task :drop do
    rake 'db:drop'
  end

  desc 'db:migrate'
  task :migrate do
    deploy.migrate
  end

end
