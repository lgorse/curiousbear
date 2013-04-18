class AddIndexToRestaurantDelta < ActiveRecord::Migration
  def change
  	 add_index :restaurants, :delta
  end
end
