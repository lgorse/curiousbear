class AddGoogleRatingIndexToRestaurants < ActiveRecord::Migration
  def change
  end
  add_index :restaurants, :google_rating
end
