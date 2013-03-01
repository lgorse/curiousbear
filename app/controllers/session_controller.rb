class SessionController < ApplicationController
	rescue_from NoMethodError, :with => :redirect_to_signin
	rescue_from Koala::Facebook::AuthenticationError, :with => :logout
	before_filter :parse_facebook_cookies, :except=>[:signin, :logout, :update_token]

	def parse_facebook_cookies
		session['fb_cookie'] ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		@access_token = session['fb_cookie']["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def signin
	
	end

	
	def home
		
	end

	def super
		
	end

	def logout
		session['fb_cookie'] = nil
    reset_session
    redirect_to root_url
	end

	def redirect_to_signin
		redirect_to root_path
	end

	def update_token
		session.delete('fb_cookie')
		parse_facebook_cookies
		
	end
end
