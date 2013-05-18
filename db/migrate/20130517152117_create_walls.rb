class CreateWalls < ActiveRecord::Migration
  def change
    create_table :walls do |t|
      t.integer :user_id, :null => false

      t.timestamps
    end
    add_index :walls, :user_id
  end
end
