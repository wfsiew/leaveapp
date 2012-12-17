class EmployeeSpouse < ActiveRecord::Base
  attr_accessible :dob, :ic, :id, :name, :occupation, :passport_no
  
  self.table_name = 'employee_spouse'
  
  validates_presence_of :name, :message => 'Name is required'
  validates_presence_of :dob, :message => 'Date of Birth is required'
  validates_presence_of :ic, :message => 'IC No. is required'
  validates_presence_of :occupation, :message => 'Occupation is required'
end
