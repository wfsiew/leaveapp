class LeaveRequest < ActiveRecord::Base
  attr_accessible :day, :from_date, :id, :leave_type_id, :reason, :to_date, :staff_id, :approve_by, :approve_datetime,
                  :status, :day_type
  
  self.table_name = 'leave_request'
  
  belongs_to :leave_type
  belongs_to :employee, :foreign_key => 'staff_id', :primary_key => 'staff_id'
  
  validates_presence_of :staff_id, :message => 'Staff ID is required'
  validates_presence_of :day, :message => 'No. of day(s) is required'
  validates_presence_of :from_date, :message => 'From Date is required'
  validates_presence_of :to_date, :message => 'To Date is required'
  validates_presence_of :leave_type_id, :message => 'Leave Type is required'
  
  validates_numericality_of :day, :greater_than => 0, :message => 'No. of day(s) is invalid'
  
  def display_status
    case :status
    when 'P' 'Pending'
    when 'A' 'Approved'
    when 'R' 'Rejected'
    when 'C' 'Canceled'
    end
  end
end
