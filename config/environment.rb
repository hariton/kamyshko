# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

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

require 'core_extensions'

require 'loader_logger'
logfile = File.open(RAILS_ROOT + '/log/loader.log', 'a')
logfile.sync = true
LOADER_LOGGER = LoaderLogger.new(logfile)

SOURCE_BASE_FILES_DIR = 'public/sources'
USER_ZIP_FILE_DIR = 'public/zip'

Footnotes::Filter.prefix = 'gvim://open?url=file://%s&amp;line=%d&amp;column=%d' if defined?(Footnotes) && RUBY_PLATFORM.include?('linux')
