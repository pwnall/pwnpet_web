class CreateNetAddresses < ActiveRecord::Migration
  def self.up
    create_table :net_addresses do |t|
      t.integer :machine_id, :null => false
      t.string :address, :length => 64, :null => false

      t.timestamps
    end
    add_index :net_addresses, :machine_id, :unique => false, :null => false
  end

  def self.down
    drop_table :net_addresses
  end
end
