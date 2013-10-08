source 'http://rubygems.org'

gem 'rails', '~> 3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'
gem "best_in_place"

# VERSION AND DEPLOYMENT
group :production do
  gem 'unicorn'
  gem 'therubyracer'
  gem 'rollbar', '~> 0.9.6'
end

gem 'sitemap_generator', :require => false
gem 'newrelic_rpm'
gem 'mysql2'

group :test do
  gem 'rspec-rails'
  gem 'rake'
  gem 'capybara'
  gem 'sunspot-rails-tester'
end

group :test, :development do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'faker'
  gem 'pry'
end

# CACHING
gem 'dalli'

# MAILER
gem 'rails_email_preview', '~> 0.2.10'

# BACKGROUND TASKS
gem 'sidekiq', :require => false
gem 'sidekiq-failures'
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'whenever', :require => false

gem 'fog'
gem 'mini_magick'
gem "carrierwave"

# SCRAPING GEMS
gem 'scrobbler'
gem 'itunes-search-api', github: 'bessey/itunes-search-api', branch: 'multi-lookup'

# ADMIN
gem 'rails_admin'
gem 'custom_configuration'

group :development do
  gem 'capistrano'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'meta_request' #, '0.2.1'
  gem 'capistrano-unicorn', :require => false

  gem 'chef', :require => false, github: "smaftoul/chef", branch: "patch-1"
  gem 'knife-solo_data_bag', :require => false
  # gem 'rack-mini-profiler'
  gem 'ruby-prof'
end

group :assets do
  # in production environments by default.
  gem 'sass-rails', '>= 3.2.3'
  gem 'compass-rails', '>= 1.0.0.rc.2'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'turbo-sprockets-rails3'
end

#gem 'client_side_validations', :github => 'bcardarella/client_side_validations', :branch => '3-2-stable'
# Authentication
gem 'devise'
gem 'cancan'

# Facebook
gem "koala"
gem "omniauth-facebook"

# Twitter
gem 'twitter'

# URL Shortener
gem 'shortener'

# Monitoring
gem 'newrelic_rpm'

gem 'kaminari'

gem 'sunspot_rails' #, :git => "git://github.com/mkrisher/sunspot.git", :branch => "task_warning_bypass"
gem 'sunspot_solr'
