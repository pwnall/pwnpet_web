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

ActiveRecord::Schema.define(:version => 20110217011648) do

  create_table "machines", :force => true do |t|
    t.string "name",   :null => false
    t.string "uid",    :null => false
    t.string "secret", :null => false
  end

  add_index "machines", ["uid"], :name => "index_machines_on_uid", :unique => true

  create_table "net_addresses", :force => true do |t|
    t.integer  "machine_id", :null => false
    t.string   "address",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "net_addresses", ["machine_id"], :name => "index_net_addresses_on_machine_id"

  create_table "ssh_credentials", :force => true do |t|
    t.integer "machine_id",         :null => false
    t.string  "username",           :null => false
    t.string  "scrambled_password"
    t.text    "key"
  end

  add_index "ssh_credentials", ["machine_id", "username"], :name => "index_ssh_credentials_on_machine_id_and_username", :unique => true

end
