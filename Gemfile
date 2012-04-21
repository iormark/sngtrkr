source 'https://rubygems.org'

gem 'rails', '3.2.2'

# JS
group :production do
  gem 'therubyracer'
end
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'json'

# VERSION AND DEPLOYMENT
group :production do
  gem 'passenger'
  gem 'mysql2'
  #gem 'activerecord-mysql-adapter'
end

group :development do
  gem 'sqlite3'
end

gem 'capistrano'
gem 'rvm'
gem 'rvm-capistrano'

# BACKGROUND TASKS
gem 'daemons'
gem "delayed_job",  :git => 'git://github.com/collectiveidea/delayed_job.git'
gem 'delayed_job_active_record'

# SCRAPING GEMS
gem 'rbrainz'
gem 'scrobbler'
gem 'itunes-search'

# ADMIN
gem 'rails_admin'


# in production environments by default.
group :assets do
  gem 'sass-rails',   '>= 3.2.3'
  #gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails', '>= 1.0.0.rc.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem "koala", "~> 1.4.0"
gem 'devise'
gem "omniauth-facebook"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'
