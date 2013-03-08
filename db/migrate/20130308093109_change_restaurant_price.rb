class ChangeRestaurantPrice < ActiveRecord::Migration
  def up
  	add_column :users, :price, :decimal
  end

  def down
  	remove_column :users, :google_price
  end
end
