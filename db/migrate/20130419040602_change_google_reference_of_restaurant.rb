class ChangeGoogleReferenceOfRestaurant < ActiveRecord::Migration
  def change
  	change_column :restaurants, :google_reference, :text
  end
end
