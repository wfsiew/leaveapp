class CreateEmployeeMembership < ActiveRecord::Migration
  def change
    create_table :employee_membership, { :primary_key => 'id' } do |t|
      t.string :id, :null => false, :limit => 40
      t.string :membership_no, :null => false
      t.integer :year, :null => false
    end
    
    change_column :employee_membership, :id, :string, :limit => 40
  end
end
