class JobCategory < ActiveRecord::Base
  attr_accessible :id, :name
  
  self.table_name = 'job_category'
  
  validates_presence_of :name, :message => 'Name is required'
  validates_uniqueness_of :name, :message => "Category %{value} already exist"
end
