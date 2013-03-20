class RestaurantsController < ApplicationController
	include RestaurantsHelper, ReviewsHelper

	before_filter :authenticate

	def index
		@restaurant_list = Restaurant.trust_search(params[:search], @current_user)
		@recommended_google_ids = []
		@encoded_search = Base64.urlsafe_encode64(params[:search])
		if @restaurant_list.empty?
			flash.now[:notice] = "No friend reviews. Check out these Google reviews!"
			search_google_from_params
			render 'restaurants/google_search'			
		end
	end

	def google_search
		search_google_from_params
		respond_to do |format|
			format.html
			format.js
		end
	end

	def new	
		@search = Base64.decode64(params[:search])
		@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:venue_data])))
		@reference = @venue["google_reference"]
		@lat =  @venue["lat"]
		@lng =  @venue["lng"]
		@google_id = @venue["google_id"]
		@restaurant = Restaurant.find_by_google_id(@google_id)
		respond_to do |format|
			format.html
			format.js
		end

	end

	def show
		@restaurant = Restaurant.find(params[:id])
		@search = @restaurant.keywords
		@reference = @restaurant.google_reference
		@venue = get_restaurant_from_reference
		@lat = @venue["geometry"]["location"]["lat"]
		@lng = @venue["geometry"]["location"]["lng"]
		@google_id = @restaurant.google_id
		respond_to do |format|
			format.html
			format.js
		end
	end




end
