#
# Cookbook Name:: sngtrkr
# Recipe:: development
#
# Reliant on common

# English is missing for this Ubuntu image for some reason?
package "language-pack-en"

directory "/home/vagrant/sngtrkr_rails_dev" do
	action :create
	owner "vagrant"
	group "vagrant"
end

execute "bundle install for the development area" do
	command "bundle install"
	cwd "/home/vagrant/sngtrkr_rails_dev"
end

# Create test/development DB if it doesn't exist
execute "create test/development db" do
	cwd "/home/vagrant/sngtrkr_rails_dev"
	command "rake db:setup RAILS_ENV=development"
	not_if do
		secrets = data_bag_item("sngtrkr", "secrets")
		(system("mysql -u root -p#{secrets['SNGTRKR_DB_PW']} -e \"SHOW DATABASES;\" | grep sngtrkr_dev_db") or
			File.exists? "/home/vagrant/sngtrkr_rails_dev/dev_db.sql")
	end
end

execute "stop development server" do
	cwd "/home/vagrant/sngtrkr_rails_dev"
	command "kill -9 $(cat `pwd`/tmp/pids/webrick.pid)"
	only_if do
		File.exists? "/home/vagrant/sngtrkr_rails_dev/tmp/pids/webrick.pid"
	end
	ignore_failure true
end

execute "stop development sidekiq client" do
	cwd "/home/vagrant/sngtrkr_rails_dev"
	command "kill -9 $(cat `pwd`/tmp/pids/sidekiq.pid)"
	only_if do
		File.exists? "/home/vagrant/sngtrkr_rails_dev/tmp/pids/sidekiq.pid"
	end
	ignore_failure true
end

execute "start development server" do
	cwd "/home/vagrant/sngtrkr_rails_dev"
	command "rails server -d --pid `pwd`/tmp/pids/webrick.pid"
end

execute "start development sidekiq client" do
	cwd "/home/vagrant/sngtrkr_rails_dev"
	command "sidekiq -d --pidfile `pwd`/tmp/pids/sidekiq.pid -L `pwd`/log/sidekiq.log"
end

execute "start solr server (silent failure possible)" do
	cwd "/home/vagrant/sngtrkr_rails_dev"
	command "rake sunspot:solr:start"
	ignore_failure true
end

# Load in our database copy if available
include_recipe "sngtrkr::seed_database"