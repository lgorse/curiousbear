class SessionController < ApplicationController
	include UsersHelper, ReviewsHelper
	
	rescue_from NoMethodError, :with => :redirect_to_signin
	rescue_from Koala::Facebook::AuthenticationError, :with => :logout
	before_filter :authenticate, :only=>[:home]
	after_filter :reset_user_session, :only=>[:signin]
	
	def signin

	end

	def register

	end

	
	def home
		@title = "Search the world, "+@current_user.first_name
		respond_to do |format|
			format.html
			format.js
		end 
		
	end

	
	def logout
		reset_reviews_cache
		reset_user_session
		redirect_to root_path
	end

	def info
		respond_to do |format|
			format.html
			format.js
		end 
	end
	

	
end
