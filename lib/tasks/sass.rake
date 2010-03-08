namespace :sass do
  desc 'Updates stylesheets from their SASS templates.'
  task :update => :environment do
    Sass::Plugin.update_stylesheets
  end
end
