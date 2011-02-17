class CreateSshCredentials < ActiveRecord::Migration
  def self.up
    create_table :ssh_credentials do |t|
      t.integer :machine_id, :null => false
      t.string :username, :length => 32, :null => false
      t.string :password, :length => 64, :null => true
      t.text :key, :length => 2.kilobytes, :null => true
    end
    add_index :ssh_credentials, [:machine_id, :username], :unique => true,
                                :null => false
  end

  def self.down
    drop_table :ssh_credentials
  end
end
