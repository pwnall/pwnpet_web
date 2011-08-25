class CreateCommandResults < ActiveRecord::Migration
  def change
    create_table :command_results do |t|
      t.integer :shell_session_id, :null => false
      t.integer :exit_code, :null => true
      t.text :command, :null => false, :length => 1024
      t.text :stdin, :null => true, :length => 64.kilobytes
      t.text :stdout, :null => false, :length => 64.kilobytes
      t.text :stderr, :null => false, :length => 64.kilobytes

      t.timestamp :created_at
    end
    add_index :command_results, [:shell_session_id, :id], :unique => true
  end
end
