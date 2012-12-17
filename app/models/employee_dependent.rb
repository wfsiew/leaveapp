class EmployeeDependent < ActiveRecord::Base
  attr_accessible :dob, :id, :name, :relationship
  
  self.table_name = 'employee_dependent'
  
  validates_presence_of :name, :message => 'Name is required'
  validates_presence_of :relationship, :message => 'Relationship is required'
end
