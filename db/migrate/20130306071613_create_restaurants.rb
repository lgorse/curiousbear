class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
    	t.string :name, :null => false
    	t.string :google_photo
    	t.integer :google_price
    	t.integer :google_rating
    	t.float		:lat, :precision => 6, :scale => 10
    	t.float		:lng, :precision => 6, :scale => 10
    	t.string	:google_id, :null => false
    	t.string	:google_reference
    	t.text		:keywords
    	t.text		:google_types, :default => "restaurant, establishment, food"
    	t.string	:formatted_address
    	t.string	:street_number
    	t.string	:street
    	t.string	:city
    	t.string	:admin_area
    	t.string	:zip
    	t.string	:country
    	t.string 	:phone


      t.timestamps
    end
  end
end
