# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Hijack rails initializer to load the bundler gem environment before loading the rails environment.
Rails::Initializer.module_eval do
  alias load_environment_without_bundler load_environment

  def load_environment
    Bundler.require_env configuration.environment
    load_environment_without_bundler
  end
end

Rails::Initializer.run do |config|
  # все зависимости переместились в ../Gemfile

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  config.time_zone = 'Moscow'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

require 'loader_logger'
logfile = File.open(RAILS_ROOT + '/log/loader.log', 'a')
logfile.sync = true
LOADER_LOGGER = LoaderLogger.new(logfile)

SOURCE_BASE_FILES_DIR = 'public/sources'
USER_ZIP_FILE_DIR = 'public/zip'
