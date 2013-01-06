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
  
  PENDING = 'P'
  APPROVED = 'A'
  
  def display_status
    case self.status
    when 'P' then 'Pending' 
    when 'A' then 'Approved'
    when 'R' then 'Rejected'
    else 'Canceled'
    end
  end
  
  def display_date
    if self.from_date == self.to_date
      self.from_date.strftime('%d-%m-%Y')
      
    else
      from = self.from_date.strftime('%d-%m-%Y')
      to = self.to_date.strftime('%d-%m-%Y')
      "#{from} to #{to}"
    end
  end
  
  def can_modify_status
    self.status != 'C' && self.status != 'R' ? true : false
  end
  
  def actions
    if self.status == 'P'
      [['Approve', 'A'], ['Reject', 'R'], ['Cancel', 'C']]
      
    elsif self.status == 'A'
      [['Cancel', 'C']]
    end
  end
  
  def user_can_modify_status
    self.status != 'C' && self.status != 'R' ? true : false
  end
  
  def user_actions
    if self.status == 'P'
      [['Cancel', 'C']]
      
    elsif self.status == 'A'
      [['Cancel', 'C']]
    end
  end
end
