# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'securerandom'

User.delete_all
Employee.delete_all
EmployeeContact.delete_all
EmployeeEcContact.delete_all
EmployeeDependent.delete_all
EmployeeJob.delete_all
EmployeeSpouse.delete_all
EmployeeSalary.delete_all
EmployeeQualification.delete_all
EmployeeMembership.delete_all

LeaveType.delete_all
LeaveRule.delete_all
Leave.delete_all

Designation.delete_all
Department.delete_all
JobCategory.delete_all
EmploymentStatus.delete_all

des = Designation.create({title: 'Programmer'})
dep = Department.create({name: 'Information System'})
jc = JobCategory.create({name: 'Development'})
es = EmploymentStatus.create({name: 'Probation'})
es1 = EmploymentStatus.create({name: 'Confirmed'})
es2 = EmploymentStatus.create({name: 'Terminated'})

us = User.new
us.id = SecureRandom.uuid
us.role = 1
us.username = 'ben'
us.status = true
us.pwd = 'ben123'
us.pwd_confirmation = 'ben123'
us.save

x = Employee.new
x.id = SecureRandom.uuid
x.staff_id = 'S0003'
x.first_name = 'Lim'
x.middle_name = 'Gun'
x.last_name = 'Min'
x.new_ic = '5599888'
x.gender = 'F'
x.marital_status = 'S'
x.nationality = 'Malaysian'
x.dob = '1988-06-08'
x.place_of_birth = 'k.l'
x.race = 'chinese'
x.is_bumi = false
x.dob = Date.strptime('30-08-1988', '%d-%m-%Y')
x.user_id = us.id
x.save

ActiveRecord::Base.transaction do
  employee = Employee.new
  employee.id = SecureRandom.uuid
  employee.staff_id = 'S0002'
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
  employee.dob = Date.strptime('30-08-1988', '%d-%m-%Y')
  employee.user_id = us.id
  employee.supervisor_id = x.id
  
  ect = EmployeeContact.new
  ect.id = employee.id
  ect.address_1 = 'Jalan Majun'
  ect.city = 'KL'
  ect.state = 'FT'
  ect.postcode = '56000'
  ect.country = 'Malaysia'
  ect.work_email = 'ben@yahoo.com'
  
  ecct = EmployeeEcContact.new
  ecct.id = employee.id
  ecct.name = 'Tan Joo Peng'
  ecct.relationship = 'Mother'
  
  ed = EmployeeDependent.new
  ed.id = employee.id
  ed.name = 'Lim Ooi Yun'
  ed.relationship = 'Daughter'
  
  ed1 = EmployeeDependent.new
  ed1.id = employee.id
  ed1.name = 'Bryan Lim'
  ed1.relationship = 'Son'
  
  ej = EmployeeJob.new
  ej.id = employee.id
  ej.designation_id = des.id
  ej.department_id = dep.id
  ej.employment_status_id = es1.id
  ej.job_category_id = jc.id
  ej.join_date = Time.now.to_date
  
  esp = EmployeeSpouse.new
  esp.id = employee.id
  esp.name = 'Kelly Lin'
  esp.dob = Date.new(1977, 8, 5)
  esp.ic = '67788'
  esp.occupation = 'Singer'
  
  esa = EmployeeSalary.new
  esa.id = employee.id
  esa.salary = 5000
  esa.bank_name = 'Maybank'
  esa.bank_acc_no = '00887766'
  esa.bank_acc_type = 'Savings'
  esa.bank_address = 'Sri Petaling'
  esa.epf_no = '6674433'
  esa.allowance = 0
  
  eq = EmployeeQualification.new
  eq.id = employee.id
  eq.level = 2
  eq.institute = 'Taylors College'
  eq.year = 2004
  eq.start_date = Date.new(1998, 2, 06)
  eq.end_date = Date.new(2004, 5, 9)
  
  em = EmployeeMembership.new
  em.id = employee.id
  em.membership_no = '008877666'
  em.year = '2001'

  employee.save
  ect.save
  ecct.save
  ed.save
  ed1.save
  ej.save
  esp.save
  esa.save
  eq.save
  em.save
end

le = LeaveType.new
le.name = 'Annual'
le.admin_adjust = true
le.admin_assign = true
le.employee_apply = true

le1 = LeaveType.new
le1.name = 'Emergency'
le1.admin_adjust = true
le1.admin_assign = true
le1.employee_apply = true

le.save
le1.save

lr = LeaveRule.new
lr.leave_type_id = le.id
lr.employment_status_id = es1.id
lr.save

lr1 = LeaveRule.new
lr1.leave_type_id = le1.id
lr1.employment_status_id = es1.id
lr1.save

lea = Leave.new
lea.id = SecureRandom.uuid
lea.staff_id = 'S0002'
lea.leave_type_id = le.id
lea.day = 1
lea.from_date = Date.new(2012, 12, 25)
lea.to_date = Date.new(2012, 12, 25)
lea.reason = 'Clear leave'
lea.status = 'P'
lea.day_type = 0
lea.save
