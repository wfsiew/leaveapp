# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121217040739) do

  create_table "department", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "department", ["name"], :name => "name", :unique => true

  create_table "designation", :force => true do |t|
    t.string "title", :null => false
    t.string "desc"
    t.string "note"
  end

  add_index "designation", ["title"], :name => "title", :unique => true

  create_table "employee", :force => true do |t|
    t.string  "employee_id",                 :null => false
    t.string  "first_name",                  :null => false
    t.string  "middle_name"
    t.string  "last_name",                   :null => false
    t.string  "new_ic",                      :null => false
    t.string  "old_ic"
    t.string  "passport_no"
    t.string  "gender",         :limit => 1, :null => false
    t.string  "marital_status", :limit => 1, :null => false
    t.string  "nationality",                 :null => false
    t.date    "dob",                         :null => false
    t.string  "place_of_birth",              :null => false
    t.string  "race",                        :null => false
    t.string  "religion"
    t.boolean "is_bumi",                     :null => false
  end

  add_index "employee", ["employee_id"], :name => "employee_id", :unique => true

  create_table "employee_contact", :force => true do |t|
    t.string "address_1",    :null => false
    t.string "address_2"
    t.string "address_3"
    t.string "city",         :null => false
    t.string "state",        :null => false
    t.string "postcode",     :null => false
    t.string "country",      :null => false
    t.string "home_phone"
    t.string "mobile_phone"
    t.string "work_email",   :null => false
    t.string "other_email"
  end

  create_table "employment_status", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "employment_status", ["name"], :name => "name", :unique => true

  create_table "job_category", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "job_category", ["name"], :name => "name", :unique => true

  create_table "leave", :force => true do |t|
    t.integer "leave_type_id", :null => false
    t.integer "day",           :null => false
    t.date    "from_date",     :null => false
    t.date    "to_date",       :null => false
    t.string  "reason"
  end

  create_table "leave_rule_1", :force => true do |t|
    t.integer "leave_type_id",        :null => false
    t.integer "employment_status_id", :null => false
  end

  create_table "leave_type", :force => true do |t|
    t.string  "name",           :null => false
    t.boolean "admin_adjust"
    t.boolean "admin_assign"
    t.boolean "employee_apply"
  end

  add_index "leave_type", ["name"], :name => "name", :unique => true

end
