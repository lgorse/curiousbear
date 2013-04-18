module RestaurantsHelper

	def search_google_from_params
		begin
				@recommended_google_ids = params[:recommended_restaurants]
				if @recommended_google_ids.nil?
					flash.now[:notice] = "No recommendations from friends. Try Google!"
				end
				@google_response = parse_google_search
				@google_results = @google_response["results"]				
				@encoded_search = Base64.urlsafe_encode64(params[:search])
				@search = params[:search]
				flash.now[:notice] = "Google yielded no results. Did you type gibberish?" if google_results_except_recommended.empty?
				handle_google_http_errors
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
				Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError,
				URI::InvalidURIError => e
				flash.now[:notice] = "Oops!" + e.message + "! That's not good."
			end
	end

	def parse_google_search	
		query = URI.escape(params[:search]) 

		url_params = "json?query="+ query + "&key="+ GOOGLE_API_KEY + "&sensor="+ false.to_s + 
					 "&location="+@current_user.lat.to_s+"," + @current_user.long.to_s +
					 "&radius=20"+"&types="+GOOGLE_TYPES.join(URI.encode("|"))

		url_params << "&pagetoken="+params[:next_token] if params[:next_token]
		url = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/"+url_params)
		
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(url.request_uri)
		
		result = http.request(request)
		JSON.parse(result.body)		
	end

	

	


	def get_details(entry)
		url_params = "json?reference="+ entry["google_reference"] + "&key=" + GOOGLE_API_KEY + "&sensor=" + false.to_s
		url = URI.parse("https://maps.googleapis.com/maps/api/place/details/"+url_params)

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(url.request_uri)

		result = http.request(request)
		JSON.parse(result.body)
	end

	def set_attr_from_google(google_response)
		google_attr = { :name => google_response["name"], 
			:formatted_address => google_response["formatted_address"],
			:google_rating => google_response["rating"], 
			:google_id => google_response["id"],
			:google_types => google_response["types"].join(","), 
			:google_reference => google_response ["reference"],
			:google_price => google_response["price_level"], 
			:lat => google_response["geometry"]["location"]["lat"].to_d,
			:lng => google_response["geometry"]["location"]["lng"].to_d,
		}
	end

	def split_formatted_address(address)
		address.split(", ", 2)
	end

	def handle_google_http_errors
		case @google_response["status"]
		when "ZERO_RESULTS" then flash.now[:notice] = "Oops! We came up empty."
		when "OVER_QUERY_LIMIT" then flash.now[:notice] = "We're more popular than we thought! We are over our query limit for today."
		when "INVALID_REQUEST" then flash.now[:notice] = "The request was invalid"
		when "REQUEST_DENIED" then flash.now[:notice] = "The request was denied"
		end
	end

	
	def get_restaurant_from_reference
		url_params = "json?key="+ GOOGLE_API_KEY + "&sensor="+ false.to_s + "&reference="+@reference
		url = URI.parse("https://maps.googleapis.com/maps/api/place/details/"+url_params)
		

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(url.request_uri)
		
		result = http.request(request)
		JSON.parse(result.body)["result"]
	end

	def set_google_restaurant_values(result)
		venue = set_attr_from_google(result)
		@encoded_venue = Base64.urlsafe_encode64(URI.encode(venue.to_json))
		
		@venue_json = {"name" => venue[:name]}.to_json

		@restaurant = Restaurant.find_or_create_by_google_id(venue[:google_id], final_restaurant_attributes(venue))

		@parsed_address = split_formatted_address(venue[:formatted_address].to_s)
		
	end

	def set_stored_restaurant_values(venue)
		@encoded_venue = Base64.urlsafe_encode64(URI.encode(venue.to_json))
		@restaurant = venue
		@parsed_address = split_formatted_address(venue.formatted_address.to_s)
		@venue_json = {"name" => venue.name}.to_json
		@google_id = venue.google_id
		@recommended_google_ids << venue.google_id if @recommended_google_ids
	end

	def final_restaurant_attributes(venue)
		venue.merge(:google_types => venue[:google_types])
		
	end

	def google_results_except_recommended
		if @recommended_google_ids.nil?
			@google_results_except_recommended = @google_results
		else
			@google_results_except_recommended = @google_results.reject{|result| @recommended_google_ids.include?(result["id"])}
		end
	end

	def reviewer_list(venue, limit_number)
		reviewer_list = venue.reviews.limit(limit_number).collect {|review| link_to review.user.name, review.user}.join(" , ")
		simple_format word_wrap("Reviewed by: " + reviewer_list, :line_width => 70)
	end

	def update_restaurant
			@restaurant.update_attributes(set_attr_from_google(@venue))
	end

end
