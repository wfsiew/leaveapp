# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'securerandom'

employee = Employee.new
employee.id = SecureRandom.uuid
employee.employee_id = 'S0002'
employee.first_name = 'Lim'
employee.middle_name = 'Gun'
employee.last_name = 'Min'
employee.new_ic = '5599888'
employee.gender = 'F'
employee.marital_status = 'S'
employee.nationality = 'Malaysian'
employee.dob = '1988-06-08'
employee.place_of_birth = 'k.l'
employee.race = 'chinese'
employee.is_bumi = false

employee.save
