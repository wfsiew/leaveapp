class EmploymentStatus < ActiveRecord::Base
  attr_accessible :id, :name
  
  self.table_name = 'employment_status'
  
  validates_presence_of :name, :message => 'Name is required'
  validates_uniqueness_of :name, :message => "Employment Status %{value} already exist"
end
