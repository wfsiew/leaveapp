module LeaveSummaryHelper
  def self.get_employee_leave_entitlement(empid, leavetype, year)
    m = { :day =>  0.00, :balance => 0.00, :taken => 0.00 }
    o = LeaveEntitlement.where(:id => empid, :leave_type_id => leavetype, :year => year).first
    if o.present?
      balance = o.day - o.taken
      m = { :day => o.day, :balance => balance, :taken => o.taken }
    end
    
    m
  end
end
