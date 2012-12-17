class CreateLeaveType < ActiveRecord::Migration
  def change
    create_table :leave_type, { :primary_key => :id } do |t|
      t.integer :id, :null => false
      t.string :name, :null => false
      t.boolean :admin_adjust
      t.boolean :admin_assign
      t.boolean :employee_apply
    end
    
    add_index :leave_type, [:name], { :name => 'name', :unique => true }
  end
end
