class CreateLeaveRule < ActiveRecord::Migration
  def change
    create_table :leave_rule, { :id => false, :force => true } do |t|
      t.integer :leave_type_id, :null => false
      t.integer :employment_status_id, :null => false
    end
  end
end
