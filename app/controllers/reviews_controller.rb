class ReviewsController < ApplicationController
	include RestaurantsHelper, ReviewsHelper

before_filter :authenticate

def new
	@user = @current_user
	@search = Base64.decode64(params[:search_field])
	@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:venue_field])))
	@review = Review.new;
end

def create
	@user = @current_user
	@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:review][:venue])))
	@restaurant = Restaurant.find_or_create_by_google_id(@venue["id"], set_attr_from_google(@venue.merge(
								:lat => nil, :lng => nil, :google_price => nil)))
	@attr = set_review_attributes(params[:review], @restaurant.id, @user.id)
	Review.create!(@attr)
	#ADD REDIRECT
end

end
