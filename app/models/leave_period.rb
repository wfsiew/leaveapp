class LeavePeriod < ActiveRecord::Base
  attr_accessible :from_date, :id, :to_date
  
  self.table_name = 'leave_period'
  
  validates_presence_of :from_date, :message => 'From date is required'
end
