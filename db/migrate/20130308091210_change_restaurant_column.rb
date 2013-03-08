class ChangeRestaurantColumn < ActiveRecord::Migration
  def change
  	change_column :restaurants, :google_rating, :float
  end
end
