class RestaurantsController < ApplicationController
	include RestaurantsHelper

before_filter :authenticate

def index
	
end

def google_search
	@google_results = parse_google_search
end

def new
	
end




end
