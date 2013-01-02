module EmployeeSpouseHelper
  def self.get_errors(errors, attr = {})
    m = {}
    { :error => 1, :errors => errors }
  end
  
  def self.is_empty_params?(params)
    q = params[:employee_spouse]
    if q[:name].blank? && q[:dob].blank? && q[:ic].blank? && q[:passport_no].blank? && q[:occupation].blank?
      return true
    end
    false
  end
  
  def self.employee_spouse_obj(o, params)
    q = params[:employee_spouse]
    
    _dob = q[:dob]
    dob = Date.strptime(_dob, ApplicationHelper.date_fmt) if _dob.present?
    
    EmployeeSpouse.new(:id => o.id, :name => q[:name], :dob => dob, :ic => q[:ic], :passport_no => q[:passport_no], 
                       :occupation => q[:occupation])
  end
  
  def self.update_obj(o, params)
    q = params[:employee_spouse]
    
    _dob = q[:dob]
    dob = Date.strptime(_dob, ApplicationHelper.date_fmt) if _dob.present?
    
    o.update_attributes(:name => q[:name], :dob => dob, :ic => q[:ic], :passport_no => q[:passport_no], 
                        :occupation => q[:occupation])
  end
end
