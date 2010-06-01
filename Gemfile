# external dependencies:
#     sphinx
#   для извлечения картинок из pdf'а требуется утилита pdfimages (из пакета poppler-utils)
#     apt-get install poppler-utils
#   для работы rmagick требуется ImageMagick с библиотеками:
#     apt-get install imagemagick libmagick9-dev
# development:
#   graphviz (включает dot- и neato-утилиты необходимые для railroad)

source :rubygems

gem 'rails',                     '2.3.8'
gem 'pg',                        '0.9.0'
gem 'whenever',                  '0.4.2'                                                      # http://github.com/javan/whenever
gem 'haml',                      '3.0.6'                                                      # http://haml-lang.com/
gem 'authlogic',                 '2.1.2'                                                      # http://github.com/binarylogic/authlogic/tree/master
gem 'declarative_authorization', '0.4.1'                                                      # http://github.com/stffn/declarative_authorization
gem 'will_paginate',             '2.3.12'                                                     # http://github.com/mislav/will_paginate/tree/master
gem 'russian',                   '0.2.7'                                                      # http://github.com/yaroslav/russian
gem 'acts_as_list',              '0.1.2'                                                      # http://github.com/rails/acts_as_list
gem 'delayed_job',               '2.0.3'                                                      # http://github.com/collectiveidea/delayed_job
gem 'mini_magick',               '1.2.5'                                                      # http://github.com/probablycorey/mini_magick
gem 'thinking-sphinx',           '1.3.16', :require => 'thinking_sphinx'                      # http://github.com/freelancing-god/thinking-sphinx/tree/master
gem 'ts-delayed-delta',          '1.1.0',  :require => 'thinking_sphinx/deltas/delayed_delta' # http://github.com/freelancing-god/ts-delayed-delta
gem 'gravtastic',                '2.2.0'                                                      # http://github.com/chrislloyd/gravtastic
gem 'rubyzip',                   '0.9.4',  :require => 'zip/zipfilesystem'                    # http://rubyzip.sourceforge.net/
gem 'request-log-analyzer',      '1.7.0'                                                      # http://github.com/wvanbergen/request-log-analyzer
gem 'memcache-client',           '1.8.3',  :require => 'memcache'                             # http://github.com/mperham/memcache-client
gem 'system_timer',              '1.0'                                                        # http://rubygems.org/gems/system_timer

group :test do
  gem 'test-unit',               '2.0.7'
  gem 'rspec',                   '1.3.0'
  gem 'rspec-rails',             '1.3.2'
  gem 'rcov',                    '0.9.8'
  gem 'shoulda',                 '2.10.3'                                                     # http://github.com/thoughtbot/shoulda
end
