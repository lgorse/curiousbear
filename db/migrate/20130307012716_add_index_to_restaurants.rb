class AddIndexToRestaurants < ActiveRecord::Migration
  def change
  end
  add_index :restaurants, :google_id
end
