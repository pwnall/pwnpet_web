class CreateShellSessions < ActiveRecord::Migration
  def change
    create_table :shell_sessions do |t|
      t.integer :machine_id, :null => false
      t.string :username, :length => 32, :null => false
      t.text :reason, :length => 1024, :null => true
      t.timestamp :created_at
    end
    add_index :shell_sessions, [:machine_id, :username, :created_at],
                               :null => false, :unique => false
  end
end
