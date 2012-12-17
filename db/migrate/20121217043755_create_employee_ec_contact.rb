class CreateEmployeeEcContact < ActiveRecord::Migration
  def change
    create_table :employee_ec_contact, { :primary_key => 'id' } do |t|
      t.string :id, :null => false, :limit => 40
      t.string :name, :null => false
      t.string :relationship, :null => false
      t.string :home_phone
      t.string :mobile_phone
      t.string :work_phone
    end
    
    change_column :employee_ec_contact, :id, :string, :limit => 40
  end
end
