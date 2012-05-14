# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
User.create!(:first_name => 'Billy', :last_name => 'Dallimore', :fbid => "660815460", :email => "test@tom.com",:password => 'test42343egysfdf')
User.create!(:first_name => 'Matt', :last_name => 'Bessey', :fbid => "757635703", :email => "bessey@gmail.com",:password => 'test42343egy20df')
User.create!(:first_name => 'Barry', :last_name => 'Smith', :fbid => "123456789", :email => "test@private.com",:password => 'test42343egy76df')