class AddDeltaColumnToRestaurants < ActiveRecord::Migration
  def change
  	add_column :restaurants, :delta, :boolean, :default => true, :null => false
  end
end
