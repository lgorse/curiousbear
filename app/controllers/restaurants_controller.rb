class RestaurantsController < ApplicationController
	include RestaurantsHelper, ReviewsHelper

	rescue_from NoMethodError, :with => :redirect_to_signin
	before_filter :authenticate

	
	def index
		Rails.cache.delete('google_back_num')
		@restaurant_list = Restaurant.trust_search(params[:search], @current_user)
		flash[:notice] = "No friend reviews yet, but check out these Google results" if @restaurant_list.blank?
		@recommended_google_ids = []
		@restaurant_list.each {|restaurant| @recommended_google_ids << restaurant.google_id}
		@encoded_search = Base64.urlsafe_encode64(params[:search])
		@search = params[:search]
		search_google_from_params	
	end

	def new	
		@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:venue_data])))
		@restaurant = Restaurant.find_or_create_by_google_id(@venue["google_id"], final_restaurant_attributes(@venue))
		puts URI.encode(@restaurant.name)
		respond_to do |format|
			format.html {redirect_to restaurant_path(@restaurant, :search => params[:search])}
			format.js 
			format.json {render :json => {:id => @restaurant.id, :name => URI.encode(@restaurant.name)}}
		end
	end



	def show
		@restaurant = Restaurant.find(params[:id])
		@search = Base64.decode64(params[:search]) if params[:search]
		@restaurant.update_restaurant_from_google_reference
		@google_id = @restaurant.google_id
		respond_to do |format|
			format.html
			format.js
			format.json {render :json => {:id => params[:id], :search => params[:search]}}
		end
	end

	def create
		@restaurant = Restaurant.create(final_restaurant_attributes(params[:venue]))
		respond_to do |format|
			format.html {redirect_to @restaurant.id}
			format.json {render :json => {:id => @restaurant.id, :name => URI.encode(@restaurant.name)}}
		end
	end


end
