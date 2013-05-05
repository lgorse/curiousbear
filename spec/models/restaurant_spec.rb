# == Schema Information
#
# Table name: restaurants
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  google_photo      :string(255)
#  google_price      :integer
#  google_rating     :float
#  lat               :float
#  lng               :float
#  google_id         :string(255)      not null
#  google_reference  :text
#  keywords          :text
#  google_types      :text             default("restaurant, establishment, food")
#  formatted_address :string(255)
#  street_number     :string(255)
#  street            :string(255)
#  city              :string(255)
#  admin_area        :string(255)
#  zip               :string(255)
#  country           :string(255)
#  phone             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  delta             :boolean          default(TRUE), not null
#  average           :integer          default(0)
#  google_url        :string(255)
#

require 'spec_helper'

describe Restaurant do
  before(:each) do
	@restaurant_attr = { :name => "restaurant", 
						:formatted_address => "Everywhere, Paris, France",
						:google_rating => 4.5, 
						:google_id => "xxx",
						:google_types => "restaurant, bar", 
						:google_reference => "xsdlgdg",
						:google_price => 2, 
						:lat => 0.45,
						:lng => 20.2
		}
	

	end

	describe "model" do

		 it "should not allow duplicate restaurants" do
		 	@restaurant = Restaurant.create!(@restaurant_attr)
		 	@restaurant2 = Restaurant.new(@restaurant_attr)
		 	@restaurant2.should_not be_valid

		 end
	end

	describe "dependencies" do

		before(:each) do
			@restaurant = Restaurant.create!(@restaurant_attr)
			@review_attr = {:user_id => 2,
							:restaurant_id => @restaurant.id,
							:rating => 4.5,
							:text => "Not bad",
							:keywords => "romantic, french"
							}
		end

		it "should respond to reviews from the user" do
			@review = Review.create(@review_attr)
			@restaurant.reviews.should be_present 
		end
	end
end
