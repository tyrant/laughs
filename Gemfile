source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.1'

# Use Postgres as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'jasmine'
  gem 'jasmine-rails'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'database_cleaner'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '~> 3.6'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-rbenv-install'
  gem 'capistrano-passenger'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'nokogiri'
gem 'awesome_print'
gem 'google_places'
gem 'underscore-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'whenever'
gem 'paperclip'
gem 'react-rails'
gem "sprockets"
gem "sprockets-es6"
gem 'font-awesome-rails'
gem 'rb-readline' # Without this, postgres 9.62 is incompatible with rails c
gem 'timezone'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'devise'
gem 'omniauth-facebook'

# Ubuntu server: don't forget http://stackoverflow.com/questions/34708211/getting-rgeo-geos-support-to-work-in-a-rails-app-deployed-to-dokku
gem 'activerecord-postgis-adapter'

gem 'baby_squeel'
gem 'dalli'

# Normally these are in :development, :test, but we'll be using these to scrape
# Sara Pascoe's site, and others.
gem 'capybara'
gem 'capybara-webkit'
gem 'capybara-angular'