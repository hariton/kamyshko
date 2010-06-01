namespace :db do

  desc 'db:create'
  task :create do
    rake 'db:create'
  end

  desc 'db:drop'
  task :drop do
    rake 'db:drop'
  end

  desc 'db:seed'
  task :seed do
    rake 'db:seed'
  end

  desc 'db:migrate'
  task :migrate do
    deploy.migrate
  end

  desc 'db:load_files'
  task :load_files do
    rake 'db:load_files'
  end

end
