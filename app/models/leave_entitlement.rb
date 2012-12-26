class LeaveEntitlement < ActiveRecord::Base
  attr_accessible :day, :id, :leave_type_id, :taken, :year
  
  self.table_name = 'leave_entitlement'
  
  belongs_to :leave_type
  belongs_to :employee, :foreign_key => 'id'
  
  validates_presence_of :day, :message => 'Day(s) entitled is required'
  validates_presence_of :id, :message => 'Employee ID is required'
  validates_presence_of :leave_type_id, :message => 'Leave Type is required'
  validates_presence_of :taken, :message => 'Day(s) taken is required'
  validates_presence_of :year, :message => 'Year is required'
  
  validates_numericality_of :day, :greater_than_or_equal_to => 0, :message => 'Day(s) entitled is invalid'
  validates_numericality_of :taken, :greater_than_or_equal_to => 0, :message => 'Day(s) taken is invalid'
  validates_numericality_of :year, :greater_than_or_equal_to => 2000, :message => 'Year is invalid'
end
