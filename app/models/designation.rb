class Designation < ActiveRecord::Base
  attr_accessible :id, :title, :desc, :note
  
  self.table_name = 'designation'
  
  validates_presence_of :title, :message => 'Job Title is required'
  validates_uniqueness_of :title, :message => "Job Title %{value} already exist"
end
