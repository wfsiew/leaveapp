module EmployeeEcContactHelper
  def self.get_errors(errors, attr = {})
    m = {}
    { :error => 1, :errors => errors }
  end
  
  def self.is_empty_params?(params)
    q = params[:employee_ec_contact]
    if q[:name].blank? && q[:relationship].blank? && q[:home_phone].blank? && q[:mobile_phone].blank? && q[:work_phone].blank?
      return true
    end
    false
  end
  
  def self.employee_ec_contact_obj(o, params)
    q = params[:employee_ec_contact]
    
    EmployeeEcContact.new(:id => o.id, :name => q[:name], :relationship => q[:relationship], :home_phone => q[:home_phone],
                          :mobile_phone => q[:mobile_phone], :work_phone => q[:work_phone])
  end
  
  def self.update_obj(o, params)
    q = params[:employee_ec_contact]
    
    o.update_attributes(:name => q[:name], :relationship => q[:relationship], :home_phone => q[:home_phone],
                        :mobile_phone => q[:mobile_phone], :work_phone => q[:work_phone])
  end
end
