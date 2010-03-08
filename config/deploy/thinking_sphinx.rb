namespace :thinking_sphinx do

  desc 'thinking_sphinx:configure'
  task :configure, :roles => :app do
    rake 'ts:config'
  end

  desc 'thinking_sphinx:index'
  task :index, :roles => :app do
    rake 'ts:index'
  end

  desc 'thinking_sphinx:start'
  task :start, :roles => :app do
    rake 'ts:start'
  end

  desc 'thinking_sphinx:stop'
  task :stop, :roles => :app do
    rake 'ts:stop'
  end

  desc 'thinking_sphinx:restart'
  task :restart, :roles => :app do
    rake 'ts:restart'
  end

  desc 'thinking_sphinx:rebuild'
  task :rebuild, :roles => :app do
    rake 'ts:rebuild'
  end

  desc 'thinking_sphinx:run'
  task :run, :roles => :app do
    rake 'ts:run'
  end

end

namespace :ts do

  desc 'ts:conf'
  task :conf, :roles => :app do
    thinking_sphinx.configure
  end

  desc 'ts:config'
  task :config, :roles => :app do
    thinking_sphinx.configure
  end

  desc 'ts:index'
  task :index, :roles => :app do
    thinking_sphinx.index
  end

  desc 'ts:start'
  task :start, :roles => :app do
    thinking_sphinx.start
  end

  desc 'ts:stop'
  task :stop, :roles => :app do
    thinking_sphinx.stop
  end

  desc 'ts:restart'
  task :restart, :roles => :app do
    thinking_sphinx.restart
  end

  desc 'ts:rebuild'
  task :rebuild, :roles => :app do
    thinking_sphinx.rebuild
  end

  desc 'ts:run'
  task :run, :roles => :app do
    thinking_sphinx.run
  end

end
