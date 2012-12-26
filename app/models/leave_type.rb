class LeaveType < ActiveRecord::Base
  attr_accessible :admin_adjust, :admin_assign, :employee_apply, :id, :name
  
  self.table_name = 'leave_type'
  
  has_many :leave_rule, :dependent => :destroy
  has_many :leave_request, :dependent => :destroy
  has_many :leave_entitlement, :dependent => :destroy
  
  validates_presence_of :name, :message => 'Name is required'
  validates_uniqueness_of :name, :message => "Leave Type %{value} already exist"
end
