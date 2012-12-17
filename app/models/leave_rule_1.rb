class LeaveRule1 < ActiveRecord::Base
  attr_accessible :employment_status_id, :id, :leave_type_id
  
  self.table_name = 'leave_rule_1'
end
