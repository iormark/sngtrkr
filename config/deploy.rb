set :application, "sngtrkr"
set :user, "deploy"
set :domain, 'sngtrkr.com'
set :staging_domain, 'staging.sngtrkr.com'
set :scm, 'git'
set :repository,  "https://github.com/MattBessey/sngtrkr.git"
set :scm_verbose, true

set :applicationdir, "/var/www/sngtrkr"
set :deploy_to, applicationdir
set :branch, 'master'
role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true        # This is where Rails migrations will run

# Sidekiq
require "sidekiq/capistrano"

# Whenever for cron jobs
set :whenever_command, "bundle exec whenever"
#require "whenever/capistrano"

# Only keep the latest 3 releases
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"

# Bundler for remote gem installs
require "bundler/capistrano"
# Load RVM's capistrano plugin.   
require "rvm/capistrano"

# deploy config
set :deploy_via, :remote_cache

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
 
# Generate an additional task to fire up the thin clusters
namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run "cd #{current_path} && bundle exec thin start -C thin.yml"
  end

  desc "Stop the Thin processes"
  task :stop do
    run "cd #{current_path} && bundle exec thin stop -C thin.yml"
  end

  desc "Restart the Thin processes"
  task :restart do
    run "cd #{current_path} && bundle exec thin restart -C thin.yml"
  end

  task :setup_solr_data_dir do
    run "mkdir -p #{shared_path}/solr/data"
  end
end
 
namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do 
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data"
    start
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end
end
 
after 'deploy:setup', 'deploy:setup_solr_data_dir'
