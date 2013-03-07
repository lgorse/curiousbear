module RestaurantsHelper

	def parse_google_search
		query = URI.escape(params[:search])
		url_params = "json?query="+ query + "&key="+ GOOGLE_API_KEY + "&sensor="+ false.to_s + "&types="+GOOGLE_TYPES.join("|")
		url = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/"+url_params)

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(url.request_uri)
		
		result = http.request(request)
		JSON.parse(result.body)["results"]

	end

	def get_details(entry)
		url_params = "json?reference="+ entry["reference"] + "&key=" + GOOGLE_API_KEY + "&sensor=" + false.to_s
		url = URI.parse("https://maps.googleapis.com/maps/api/place/details/"+url_params)

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(url.request_uri)

		result = http.request(request)
		JSON.parse(result.body)
	end

	def set_attr_from_google(google_response)
		google_attr = { :name => google_response["name"], :formatted_address => google_response["formatted_address"],
				  :google_rating => google_response["rating"].to_i, :google_id => google_response ["id"].to_i,
				  :google_types => google_response ["types"].join(","), :google_reference => google_response ["reference"]
		}
	end

	def split_formatted_address(address)
		address.split(", ", 2)
	end

	def search_to_keywords
		@search.gsub(/[^A-Za-z]/, ' ')
	end
end