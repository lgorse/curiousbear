class SessionController < ApplicationController
	include UserHelper
	
	#rescue_from NoMethodError, :with => :redirect_to_signin
	rescue_from Koala::Facebook::AuthenticationError, :with => :logout
	before_filter :authenticate, :only=>[:home]
	
	
	
	
	def signin

	end

	def register

	end

	
	def home

	end

	
	def logout
		session['fb_cookie'] = nil
		reset_session
		redirect_to root_path
	end

	

	

	
end
