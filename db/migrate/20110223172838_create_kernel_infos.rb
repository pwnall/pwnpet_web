class CreateKernelInfos < ActiveRecord::Migration
  def change
    create_table :kernel_infos do |t|
      t.integer :machine_id, :null => false
      t.string :name, :length => 64, :null => false
      t.string :release, :length => 64, :null => false
      t.string :version, :length => 128, :null => false
      t.string :architecture, :length => 64, :null => false
      t.string :os, :length => 64, :null => false

      t.datetime :updated_at
    end
    add_index :kernel_infos, :machine_id, :null => false, :unique => true
  end
end
