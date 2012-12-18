class LeaveRule < ActiveRecord::Base
  attr_accessible :employment_status_id, :leave_type_id
  
  self.table_name = 'leave_rule'
  
  belongs_to :leave_type
  belongs_to :employment_status
end
