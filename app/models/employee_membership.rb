class EmployeeMembership < ActiveRecord::Base
  attr_accessible :id, :membership_no, :year
  
  self.table_name = 'employee_membership'
  
  belongs_to :employee, :foreign_key => 'id'
  
  validates_presence_of :membership_no, :message => 'Membership No. is required'
  validates_presence_of :year, :message => 'Year is required'
end
