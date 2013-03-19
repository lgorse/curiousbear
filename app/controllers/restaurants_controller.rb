class RestaurantsController < ApplicationController
	include RestaurantsHelper

	before_filter :authenticate

	def index
		@restaurant_list = Restaurant.trust_search(params[:search], @current_user)
		@recommended_google_ids = []
		if @restaurant_list.empty?
		flash.now[:notice] = "No recommendations from friends. Try Google!"
	else
		@encoded_search = Base64.urlsafe_encode64(params[:search])
	end

	end

	def google_search
		begin
			@recommended_google_ids = params[:recommended_restaurants]
			@google_response = parse_google_search
			@google_results = @google_response["results"]
			flash.now[:notice] = "Google yielded no results. What you see is what you get!" if google_results_except_recommended.empty?
			@encoded_search = Base64.urlsafe_encode64(params[:search])
			handle_google_http_errors
		rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
			Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
			URI::InvalidURIError => e
			flash.now[:error] = "Oops!" + e.message + "! That's not good."
		end
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
