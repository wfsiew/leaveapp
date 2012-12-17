class EmployeeEcContact < ActiveRecord::Base
  attr_accessible :home_phone, :id, :mobile_phone, :name, :relationship, :work_phone
  
  self.table_name = 'employee_ec_contact'
  
  belongs_to :employee, :foreign_key => 'id'
  
  validates_presence_of :name, :message => 'Name is required'
  validates_presence_of :relationship, :message => 'Relationship is required'
end
