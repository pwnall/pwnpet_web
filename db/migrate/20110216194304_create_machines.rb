class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.integer :user_id, :null => false
      t.string :name, :length => 32, :null => false
      t.string :uid, :length => 32, :null => false
      t.string :secret, :length => 64, :null => false
    end
    add_index :machines, [:user_id, :name], :null => false, :unique => true
    add_index :machines, :uid, :unique => true, :null => false
  end
end
