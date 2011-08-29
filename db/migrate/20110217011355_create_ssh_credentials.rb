class CreateSshCredentials < ActiveRecord::Migration
  def change
    create_table :ssh_credentials do |t|
      t.integer :machine_id, :null => false
      t.string :username, :length => 32, :null => false
      t.string :scrambled_password, :length => 64, :null => true,
                                    :default => nil
      t.text :key, :length => 2.kilobytes, :null => true, :default => nil
      
      t.timestamp :last_used_at, :null => true
      t.timestamp :last_failed_at, :null => true

      t.timestamps      
    end
    add_index :ssh_credentials, [:machine_id, :username], :unique => true,
                                :null => false
  end
end
