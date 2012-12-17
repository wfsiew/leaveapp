class CreateEmployeeSpouse < ActiveRecord::Migration
  def change
    create_table :employee_spouse, { :primary_key => :id } do |t|
      t.string :id, :null => false, :limit => 40
      t.string :name, :null => false
      t.date :dob, :null => false
      t.string :ic, :null => false
      t.string :passport_no
      t.string :occupation, :null => false
    end
    
    change_column :employee_spouse, :id, :string, :limit => 40
  end
end
