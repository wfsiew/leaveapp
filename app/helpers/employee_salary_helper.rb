module EmployeeSalaryHelper
  def self.get_errors(errors, attr = {})
    m = {}
    { :error => 1, :errors => errors }
  end
  
  def self.is_empty_params?(params)
    q = params[:employee_salary]
    if q[:salary].blank? && q[:allowance].blank? && q[:bank_name].blank? && q[:bank_acc_no].blank? && q[:bank_acc_type].blank? &&
      q[:bank_address].blank? && q[:epf_no].blank? && q[:socso_no].blank? && q[:income_tax_no].blank?
      return true
    end
    false
  end
  
  def self.employee_salary_obj(o, params)
    q = params[:employee_salary]
    
    EmployeeSalary.new(:id => o.id, :salary => q[:salary], :allowance => q[:allowance], :bank_name => q[:bank_name], :bank_acc_no => q[:bank_acc_no],
                       :bank_acc_type => q[:bank_acc_type], :bank_address => q[:bank_address], :epf_no => q[:epf_no],
                       :socso_no => q[:socso_no], :income_tax_no => q[:income_tax_no])
  end
  
  def self.update_obj(o, params)
    q = params[:employee_salary]
    
    o.update_attributes(:salary => q[:salary], :allowance => q[:allowance], :bank_name => q[:bank_name], 
                        :bank_acc_no => q[:bank_acc_no], :bank_acc_type => q[:bank_acc_type], 
                        :bank_address => q[:bank_address], :epf_no => q[:epf_no], :socso_no => q[:socso_no], 
                        :income_tax_no => q[:income_tax_no])
  end
  
  def self.find(id)
    o = nil
    begin
      o = EmployeeSalary.find(id)
      
    rescue Exception => e
      o = EmployeeSalary.new
    end
    o
  end
end
