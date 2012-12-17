class EmployeeSalary < ActiveRecord::Base
  attr_accessible :allowance, :bank_acc_no, :bank_acc_type, :bank_address, :bank_name, :epf_no, :id, :income_tax_no, :salary, :socso_no
  
  self.table_name = 'employee_salary'
  
  belongs_to :employee, :foreign_key => 'id'
  
  validates_presence_of :salary, :message => 'Salary is required'
  validates_presence_of :bank_name, :message => 'Bank Name is required'
  validates_presence_of :bank_acc_no, :message => 'Bank Account No. is required'
  validates_presence_of :bank_acc_type, :message => 'Bank Account Type is required'
  validates_presence_of :bank_address, :message => 'Bank Address is required'
  validates_presence_of :epf_no, :message => 'EPF No. is required'
  
  validates_numericality_of :salary, :greater_than => 0, :message => 'Salary is invalid'
  validates_numericality_of :allowance, :greater_than_or_equal_to => 0, :message => 'Allowance is invalid'
end
