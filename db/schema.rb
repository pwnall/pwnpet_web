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

ActiveRecord::Schema.define(:version => 20110824161334) do

  create_table "command_results", :force => true do |t|
    t.integer  "shell_session_id", :null => false
    t.integer  "exit_code"
    t.text     "command",          :null => false
    t.text     "stdin"
    t.text     "stdout",           :null => false
    t.text     "stderr",           :null => false
    t.datetime "created_at"
  end

  add_index "command_results", ["shell_session_id", "id"], :name => "index_command_results_on_shell_session_id_and_id", :unique => true

  create_table "config_vars", :force => true do |t|
    t.string "name",  :null => false
    t.binary "value", :null => false
  end

  add_index "config_vars", ["name"], :name => "index_config_vars_on_name", :unique => true

  create_table "facebook_tokens", :force => true do |t|
    t.integer "user_id",                     :null => false
    t.string  "external_uid", :limit => 32,  :null => false
    t.string  "access_token", :limit => 128, :null => false
  end

  add_index "facebook_tokens", ["external_uid"], :name => "index_facebook_tokens_on_external_uid", :unique => true

  create_table "kernel_infos", :force => true do |t|
    t.integer  "machine_id",   :null => false
    t.string   "name",         :null => false
    t.string   "release",      :null => false
    t.string   "version",      :null => false
    t.string   "architecture", :null => false
    t.string   "os",           :null => false
    t.datetime "updated_at"
  end

  add_index "kernel_infos", ["machine_id"], :name => "index_kernel_infos_on_machine_id", :unique => true

  create_table "machines", :force => true do |t|
    t.integer "user_id", :null => false
    t.string  "name",    :null => false
    t.string  "uid",     :null => false
    t.string  "secret",  :null => false
  end

  add_index "machines", ["uid"], :name => "index_machines_on_uid", :unique => true
  add_index "machines", ["user_id", "name"], :name => "index_machines_on_user_id_and_name", :unique => true

  create_table "net_addresses", :force => true do |t|
    t.integer  "machine_id", :null => false
    t.string   "address",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "net_addresses", ["machine_id"], :name => "index_net_addresses_on_machine_id"

  create_table "shell_sessions", :force => true do |t|
    t.integer  "machine_id", :null => false
    t.string   "username",   :null => false
    t.text     "reason"
    t.datetime "created_at"
  end

  add_index "shell_sessions", ["machine_id", "username", "created_at"], :name => "index_shell_sessions_on_machine_id_and_username_and_created_at"

  create_table "ssh_credentials", :force => true do |t|
    t.integer "machine_id",         :null => false
    t.string  "username",           :null => false
    t.string  "scrambled_password"
    t.text    "key"
  end

  add_index "ssh_credentials", ["machine_id", "username"], :name => "index_ssh_credentials_on_machine_id_and_username", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",         :limit => 128, :null => false
    t.string   "email_hash",    :limit => 64,  :null => false
    t.string   "password_salt", :limit => 16
    t.string   "password_hash", :limit => 64
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["email_hash"], :name => "index_users_on_email_hash", :unique => true

end
