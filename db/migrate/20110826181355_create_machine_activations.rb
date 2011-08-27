class CreateMachineActivations < ActiveRecord::Migration
  def change
    create_table :machine_activations do |t|
      t.integer :machine_id, :null => false
      t.boolean :password_reset, :null => false
      
      t.datetime :completed_at, :null => true
      t.datetime :created_at, :null => false
    end
    add_index :machine_activations, :machine_id, :unique => true, :null => false
  end
end
