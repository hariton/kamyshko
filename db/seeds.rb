# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# add default roles and users
role_admin    = Role.create(:name => 'admin',    :title => 'Admin')
role_loader   = Role.create(:name => 'loader',   :title => 'Loader')
role_searcher = Role.create(:name => 'searcher', :title => 'Searcher')
role_user     = Role.create(:name => 'user',     :title => 'User')

role_admin.save!
role_loader.save!
role_searcher.save!
role_user.save!

# create default administrator account
user = User.create :login => 'admin'
user.password = 'admin'
user.password_confirmation = 'admin'
user.roles << role_admin
user.save!

# create default accounts
user = User.create :login => 'test01', :name => 'Test01', :email => 'test01@example.com'
user.password = 'test01'
user.password_confirmation = 'test01'
user.roles << role_admin
user.save!

user = User.create :login => 'test02', :name => 'Test02', :email => 'test02@example.com'
user.password = 'test02'
user.password_confirmation = 'test02'
user.roles << role_searcher
user.save!

user = User.create :login => 'test03', :name => 'Test03', :email => 'test03@example.com'
user.password = 'test03'
user.password_confirmation = 'test03'
user.roles << role_searcher
user.save!

user = User.create :login => 'test04', :name => 'Test04', :email => 'test04@example.com'
user.password = 'test04'
user.password_confirmation = 'test04'
user.roles << role_searcher
user.save!

user = User.create :login => 'test05', :name => 'Test05', :email => 'test05@example.com'
user.password = 'test05'
user.password_confirmation = 'test05'
user.roles << role_loader
user.save!

user = User.create :login => 'test06', :name => 'Test06', :email => 'test06@example.com'
user.password = 'test06'
user.password_confirmation = 'test06'
user.roles << role_loader
user.save!

sources = YAML.load(File.open( Rails.root.join('db', 'sources.yml')))

sources.each do |source|
  Source.create!(:title => source[0], :site_url => source[1])
end

__END__
