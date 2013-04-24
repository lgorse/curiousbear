class AddRestaurantAverageColumn < ActiveRecord::Migration
  def change
  	add_column :restaurants, :average, :integer, :default => 0
  	add_index :restaurants, :keywords
  	add_index :restaurants, :average
  end
end
