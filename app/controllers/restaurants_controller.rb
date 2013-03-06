class RestaurantsController < ApplicationController

before_filter :authenticate
def index
	query = params[:search].split.join(" ").gsub(" ", "+")
	url_params = "json?query="+ query + "&key="+ GOOGLE_API_KEY + "&sensor="+ false.to_s + "&types=restaurant|food|establishment|bar|cafe"
@url = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/"+url_params)
#@url = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=iranian+restaurant+new+york&key=#{GOOGLE_API_KEY}&sensor=false")
		http = Net::HTTP.new(@url.host, @url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(@url.request_uri)
		#request["output"] = "json?"
		#request["query"] = params[:search]
		#request["key"] = GOOGLE_API_KEY
		#request["sensor"] = "false"
		#request[:types] = ["restaurant", "food", "establishment"]
		@result = http.request(request)
		@parse = JSON.parse(@result.body)
=begin
	@client = GooglePlaces::Client.new(GOOGLE_API_KEY)
	@result = @client.spots_by_query(params[:search], :sensor => false, :types => ['restaurant', 'food', 'establishment'], :radius => 20000)
	@detail = @client.spot(@result.first.reference)
=end
	

end

end
