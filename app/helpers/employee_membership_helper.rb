module EmployeeMembershipHelper
  def self.get_errors(errors, attr = {})
    m = {}
    { :error => 1, :errors => errors }
  end
  
  def self.is_empty_params?(params)
    q = params[:employee_membership]
    if q[:membership_no].blank? && q[:year].blank?
      return true
    end
    false
  end
  
  def self.employee_membership_obj(o, params)
    q = params[:employee_membership]
    
    EmployeeMembership.new(:id => o.id, :membership_no => q[:membership_no], :year => q[:year])
  end
  
  def self.update_obj(o, params)
    q = params[:employee_membership]
    
    o.update_attributes(:membership_no => q[:membership_no], :year => q[:year])
  end
  
  def self.find(id)
    o = nil
    begin
      o = EmployeeMembership.find(id)
      
    rescue Exception => e
      o = EmployeeMembership.new
    end
    o
  end
end
