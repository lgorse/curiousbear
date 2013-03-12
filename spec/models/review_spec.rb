# == Schema Information
#
# Table name: reviews
#
#  id            :integer          not null, primary key
#  restaurant_id :integer          not null
#  user_id       :integer          not null
#  rating        :decimal(2, 1)
#  text          :text
#  keywords      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Review do
  
  before(:each) do
  @user_attr = {:name => "Laurent Gorse", :first_name => "Laurent", :birthday => '1979-05-28'.to_date,
				:gender => "male", :e_mail => "lgorse@stanford.edu", :fb_id => 123456789}
	@user = User.create!(@user_attr)
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
		@restaurant = Restaurant.create!(@restaurant_attr)
	end

	describe "create user" do

		before(:each) do
			@review_attr = {:user_id => @user.id,
							:restaurant_id => @restaurant.id,
							:rating => 4.5,
							:text => "Not bad",
							:keywords => "romantic, french"
							}
			 

		end

		it "should require a user ID" do
			review = Review.new(@review_attr.merge(:user_id => ""))
			review.should_not be_valid
		end

		it "should require a restaurant ID" do
			review = Review.new(@review_attr.merge(:restaurant_id => ""))
			review.should_not be_valid
		end

		it "should not allow duplication of restaurant and user IDs 
			(same user cannot review same restaurant twice)" do
			@review = Review.create!(@review_attr)
			@review2 = Review.new(@review_attr)
			@review2.should_not be_valid
		end

		it "should allow multiple reviews from the same user" do
			@review = Review.create!(@review_attr)
			@review2 = Review.new(@review_attr.merge(:restaurant_id => @restaurant.id+1))
			@review2.should be_valid
		end

		it "should allow multiple reviews of the same restaurant" do
			@review = Review.create!(@review_attr)
			@review2 = Review.new(@review_attr.merge(:user_id => @user.id-1))
			@review2.should be_valid
		end

	end

end
