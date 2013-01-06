module LeaveEntitlementHelper
  def self.update(id, action)
    m = LeaveRequest.find(id)
    employee_id = m.employee.id
    leave_type_id = m.leave_type_id
    year = m.from_date.year
    o = LeaveEntitlement.where(:id => employee_id, :leave_type_id => leave_type_id, :year => year)
    
    if o.any?
      x = o.first
      if action == 'A'
        taken = x.taken + m.day
        LeaveEntitlement.update_all({ :taken => taken }, ['id = ? and leave_type_id = ? and year = ?', 
                                                          employee_id, 
                                                          leave_type_id,
                                                          year])
      
      elsif m.status != 'P' && (action == 'R' || action == 'C')
        taken = x.taken - m.day
        LeaveEntitlement.update_all({ :taken => taken }, ['id = ? and leave_type_id = ? and year = ?', 
                                                          employee_id, 
                                                          leave_type_id,
                                                          year])
      end
    end
  end
end
