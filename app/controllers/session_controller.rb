class SessionController < ApplicationController
	include SessionHelper
	
	#rescue_from NoMethodError, :with => :redirect_to_signin
	rescue_from Koala::Facebook::AuthenticationError, :with => :logout
	before_filter :parse_facebook_cookies, :except=>[:signin, :logout, :update_token, :register, :register_user]

	
	def signin

	end

	def register

	end

	
	def home
		
	end

	def register_user
		signed_request = params['signed_request']
		@signed_request = decode_data(signed_request)

	end

	def logout
		session['fb_cookie'] = nil
		reset_session
		redirect_to root_path
	end

	def redirect_to_signin
		redirect_to root_path
	end

	
end
