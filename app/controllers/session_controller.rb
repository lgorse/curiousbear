class SessionController < ApplicationController
	include UsersHelper
	
	#rescue_from NoMethodError, :with => :redirect_to_signin
	rescue_from Koala::Facebook::AuthenticationError, :with => :logout
	before_filter :authenticate, :only=>[:home]
	after_filter :reset_user_session, :only=>[:signin]
	
	
	
	
	def signin

	end

	def register

	end

	
	def home
		@title = "Search the world, "+@user.first_name

	end

	
	def logout
		reset_user_session
		redirect_to root_path
	end

	

	

	
end
