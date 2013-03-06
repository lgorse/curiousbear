class RestaurantsController < ApplicationController

before_filter :authenticate
def index
	@client = GooglePlaces::Client.new(GOOGLE_API_KEY)
	@result = @client.spots_by_query(params[:search], :sensor => false, :types => ['restaurant', 'food'], :radius => 20000)
	@detail = @client.spot(@result.first.reference)
end

end
