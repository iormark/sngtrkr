require File.expand_path('../boot', __FILE__)
require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test staging)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

if ENV['SNGTRKR_AWS_ID'].blank?
  raise "Environment variables not set. Probably not in the right shell script file."
end

module SNGTRKR
  class Application < Rails::Application
    config.assets.initialize_on_precompile = false

    config.assets.precompile += ['rails_admin/rails_admin.css', 'rails_admin/rails_admin.js',
                                 'sidekiq/application.js', 'sidekiq/*.css', 'javascripts/css3-fallback.js']

    config.assets.expire_after 2.weeks


    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Default URL base for emails
    config.action_mailer.default_url_options = {:host => "sngtrkr.com"}

    config.time_zone = 'London'

    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

  end
end

