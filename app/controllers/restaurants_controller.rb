class RestaurantsController < ApplicationController
	include RestaurantsHelper

	before_filter :authenticate

	def index

	end

	def google_search
		begin
			@google_response = parse_google_search
			@google_results = @google_response["results"]
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
		@attr = JSON.parse(Base64.urlsafe_decode64(params[:venue_data]))
		@reference = @attr["reference"]
		@lat =  @attr["lat"]
		@lng =  @attr["lng"]
		respond_to do |format|
			format.html
			format.js
		end

	end




end
