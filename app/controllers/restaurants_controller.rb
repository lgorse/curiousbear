class RestaurantsController < ApplicationController

before_filter :authenticate
def index
	query = params[:search].split.join(" ").gsub(" ", "+")
	url_params = "json?query="+ query + "&key="+ GOOGLE_API_KEY + "&sensor="+ false.to_s + "&types=restaurant|food|establishment|bar|cafe"
url = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/"+url_params)

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(url.request_uri)
		
		result = http.request(request)
		parse = JSON.parse(result.body)
		@entry = parse["results"].first

		@detail = get_details(@entry)

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

end
