class CreateEmployeeDependent < ActiveRecord::Migration
  def change
    create_table :employee_dependent, { :id => false, :force => true } do |t|
      t.string :id, :null => false, :limit => 40
      t.string :name, :null => false
      t.string :relationship, :null => false
      t.date :dob
    end
    
    change_column :employee_dependent, :id, :string, :limit => 40
  end
end
