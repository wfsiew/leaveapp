# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'securerandom'

User.create(:id => SecureRandom.uuid, :username => 'admin', :pwd => 'admin123', :pwd_confirmation => 'admin123', :status => 1, 
            :role => User::ADMIN)
