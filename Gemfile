# external dependencies:
#     sphinx
#   для извлечения картинок из pdf'а требуется утилита pdfimages (из пакета poppler-utils)
#     apt-get install poppler-utils
#   для работы rmagick требуется ImageMagick с библиотеками:
#     apt-get install imagemagick libmagick9-dev
# development:
#   graphviz (включает dot- и neato-утилиты необходимые для railroad)
#
# plugins:
#   russian (bundler incompatibility)
#     http://github.com/yaroslav/russian/tree/master

source :rubygems

gem 'rails',                     '2.3.5'
gem 'postgres',                  '0.7.9.2008.01.28'
gem 'mongrel',                   '1.1.5'                                                      # http://github.com/mongrel/mongrel/
gem 'whenever',                  '0.4.1'                                                      # http://github.com/javan/whenever
gem 'haml',                      '2.2.12'                                                     # http://haml-lang.com/
gem 'authlogic',                 '2.1.2'                                                      # http://github.com/binarylogic/authlogic/tree/master
gem 'declarative_authorization', '0.4'                                                        # http://github.com/stffn/declarative_authorization
gem 'will_paginate',             '2.3.11'                                                     # http://github.com/mislav/will_paginate/tree/master
gem 'acts_as_list',              '0.1.2'                                                      # http://github.com/rails/acts_as_list
gem 'state_machine',             '0.8.0'                                                      # http://github.com/pluginaweek/state_machine
gem 'delayed_job',               '1.8.4'                                                      # http://github.com/collectiveidea/delayed_job
gem 'rmagick',                   '2.12.2', :require => 'RMagick2'                             # http://rubyforge.org/projects/rmagick/
gem 'thinking-sphinx',           '1.3.2',  :require => 'thinking_sphinx'                      # http://github.com/freelancing-god/thinking-sphinx/tree/master
gem 'ts-delayed-delta',          '1.0.0',  :require => 'thinking_sphinx/deltas/delayed_delta' # http://github.com/freelancing-god/ts-delayed-delta
gem 'gravtastic',                '2.1.0'                                                      # http://github.com/chrislloyd/gravtastic
gem 'Ascii85',                   '0.9.0',  :require => 'ascii85'                              # требуется для pdf-reader'а, http://ascii85.rubyforge.org/
gem 'pdf-reader',                '0.7.7',  :require => 'pdf/reader'                           # http://github.com/yob/pdf-reader
gem 'rubyzip',                   '0.9.1',  :require => 'zip/zipfilesystem'                    # http://rubyzip.sourceforge.net/
gem 'request-log-analyzer',      '1.6.2'                                                      # http://github.com/wvanbergen/request-log-analyzer
gem 'awesome_nested_set',        '1.4.3'                                                      # http://github.com/collectiveidea/awesome_nested_set/tree/master
gem 'memcache-client',           '1.8.0',  :require => 'memcache'                             # http://github.com/mperham/memcache-client
gem 'system_timer',              '1.0'                                                        # http://rubygems.org/gems/system_timer

group :development do
  gem 'railroad'
  gem 'hirb'
  gem 'ruby-prof',               '0.8.1'                                                      # http://github.com/jeremy/ruby-prof
  gem 'easy-prof',               '1.0.0',   :require => 'easy_prof'                           # http://github.com/kpumuk/easy-prof
  gem 'ruby-debug'
end

group :test do
  gem 'rspec',                   '1.2.9'
  gem 'rspec-rails',             '1.2.9'
  gem 'rcov',                    '0.9.5'
  gem 'shoulda',                 '2.10.3'                                                     # http://github.com/thoughtbot/shoulda
end

group :production do
end
