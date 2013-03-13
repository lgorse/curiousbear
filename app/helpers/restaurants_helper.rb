module RestaurantsHelper

	def parse_google_search		
			query = URI.escape(params[:search])
			url_params = "json?query="+ query + "&key="+ GOOGLE_API_KEY + "&sensor="+ false.to_s + "&types="+GOOGLE_TYPES.join("|")
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
						:google_id => google_response ["id"],
						:google_types => google_response ["types"].join(","), 
						:google_reference => google_response ["reference"],
						:google_price => google_response["price_level"], 
						:lat => google_response["geometry"]["location"]["lat"].to_d,
						:lng => google_response["geometry"]["location"]["lng"].to_d
		}
	end

	def split_formatted_address(address)
		address.split(", ", 2)
	end

	def search_to_keywords
		@search.gsub(/[^A-Za-z]/, ' ')
	end

	def handle_google_http_errors
		case @google_response["status"]
		when "ZERO_RESULTS" then flash[:error] = "Oops! We came up empty."
		when "OVER_QUERY_LIMIT" then flash[:error] = "We're more popular than we thought! We are over our query limit for today."
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

	def set_summary_values(result)
		@venue = set_attr_from_google(result).merge(:id => nil)

		@encoded_venue = Base64.urlsafe_encode64(URI.encode(@venue.to_json))
		
		@parsed_address = split_formatted_address(@venue[:formatted_address].to_s)
		@venue_json = {"name" => @venue[:name]}.to_json
		@google_id = @venue[:google_id]
		@restaurant = Restaurant.find_by_google_id(@google_id)
	end

	def final_restaurant_attributes(venue)
		venue.merge(:lat => nil, :lng => nil, 
					:google_price => nil,
					:google_types => venue["google_types"])
	end
end
