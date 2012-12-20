class CreateLeave < ActiveRecord::Migration
  def change
    create_table :leave, { :primary_key => 'id' } do |t|
      t.string :id, :null => false, :limit => 40
      t.string :staff_id, :null => false, :limit => 40
      t.integer :leave_type_id, :null => false
      t.float :day, :null => false
      t.date :from_date, :null => false
      t.date :to_date, :null => false
      t.string :reason
      t.string :approve_by, :limit => 40
      t.datetime :approve_datetime
      t.string :status, :limit => 1
      t.integer :day_type, :null => false
    end
    
    change_column :leave, :id, :string, :limit => 40
  end
end
