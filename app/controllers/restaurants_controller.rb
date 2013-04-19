class RestaurantsController < ApplicationController
	include RestaurantsHelper, ReviewsHelper

	#rescue_from NoMethodError, :with => :redirect_to_signin
	before_filter :authenticate
	
	def index
		@restaurant_list = Restaurant.trust_search(params[:search], @current_user)
		@recommended_google_ids = []
		@encoded_search = Base64.urlsafe_encode64(params[:search])
		@search = params[:search]
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
		@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:venue_data])))
		@restaurant = Restaurant.find_or_create_by_google_id(@venue["google_id"], final_restaurant_attributes(@venue))
		respond_to do |format|
			format.html 
			format.js 
			format.json {render :json => {:id => @restaurant.id, :name => URI.encode(@restaurant.name)}}
		end
	end



	def show
		@restaurant = Restaurant.find(params[:id])
		@search = Base64.decode64(params[:search]) if params[:search]
		@reference = @restaurant.google_reference
		@venue = get_restaurant_from_reference
		@lat = @venue["geometry"]["location"]["lat"]
		@lng = @venue["geometry"]["location"]["lng"]
		update_restaurant
		@google_id = @restaurant.google_id
		respond_to do |format|
			format.html
			format.js
			format.json
		end
	end

	def create
		puts params[:lat]
		@restaurant = Restaurant.create(final_restaurant_attributes(params[:venue]))
		respond_to do |format|
			format.html {redirect_to @restaurant.id}
			format.json {render :json => {:id => @restaurant.id, :name => URI.encode(@restaurant.name)}}
		end
	end

end
