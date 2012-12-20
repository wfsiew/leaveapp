class CreateLeaveEntitlement < ActiveRecord::Migration
  def change
    create_table :leave_entitlement, { :id => false, :force => true } do |t|
      t.string :id, :null => false, :limit => 40
      t.integer :leave_type_id, :null => false
      t.float :day, :null => false
      t.integer :year, :null => false
      t.float :balance, :null => false
      t.float :taken, :null => false
    end
    
    change_column :leave_entitlement, :id, :string, :limit => 40
  end
end
