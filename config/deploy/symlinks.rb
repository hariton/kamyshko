namespace :deploy do

  desc 'Symlink shared configs and folders on each release.'
  task :symlink_shared do
    run "ln -fs #{shared_path}/public/sources #{release_path}/public/sources"
    run "ln -fs #{shared_path}/public/zip #{release_path}/public/zip"
    run "ln -fs #{shared_path}/db/sphinx #{release_path}/db/sphinx"
  end

end
