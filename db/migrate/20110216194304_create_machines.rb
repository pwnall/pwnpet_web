class CreateMachines < ActiveRecord::Migration
  def self.up
    create_table :machines do |t|
      t.string :name, :length => 32, :null => false
      t.string :uid, :length => 32, :null => false
      t.string :secret, :length => 64, :null => false
    end
    add_index :machines, :uid, :unique => true, :null => false
  end

  def self.down
    drop_table :machines
  end
end
