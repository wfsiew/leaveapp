class CreateLeavePeriod < ActiveRecord::Migration
  def change
    create_table :leave_period do |t|
      t.integer :id
      t.date :from_date
      t.date :to_date
    end
  end
end
