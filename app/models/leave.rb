class Leave < ActiveRecord::Base
  attr_accessible :day, :from_date, :id, :leave_type_id, :reason, :to_date, :employee_id, :approve_by, :approve_datetime
                  :status
  
  self.table_name = 'leave'
  
  belongs_to :leave_type
  
  validates_presence_of :day, :message => 'No. of day(s) is required'
  validates_presence_of :from_date, :message => 'From Date is required'
  validates_presence_of :to_date, :message => 'To Date is required'
  validates_presence_of :leave_type_id, :message => 'Leave Type is required'
  
  validates_numericality_of :day, :greater_than => 0, :message => 'No. of day(s) is invalid'
end
