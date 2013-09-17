source 'https://rubygems.org'

gem 'rails', '~> 4.0.0'
gem 'pg'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.0.3'
gem 'therubyracer'

gem 'jquery-rails'

# Bundle the extra gems:
gem 'RedCloth', '~> 4.2.9', :require => 'redcloth'
gem 'ruby-openid', :require => 'openid'
gem 'rack-openid', :require => 'rack/openid'
gem 'aaronh-chronic', :require => 'chronic' # Fixes for 1.9.2
gem 'coderay', '~> 1.0.5'
gem 'lesstile', '~> 1.1.0'
gem 'formtastic'
gem 'will_paginate', '~> 3.0.2'
gem 'exception_notification', '~> 2.5.2'
gem 'open_id_authentication'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do
  gem 'database_cleaner'
  gem 'cucumber-rails', '~> 1.4.0',   :require => false
  gem 'cucumber-websteps', :require => false
  gem 'factory_girl'
  gem 'rspec'
  gem 'nokogiri', '~> 1.5.0'
  gem 'webrat'
  gem 'guard-rspec'
  gem 'rb-fsevent', :require => false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'capistrano'
  gem 'rvm-capistrano'
  gem 'sqlite3'
end

group :production do
  gem 'rack-google_analytics', :require => "rack/google_analytics"
end
