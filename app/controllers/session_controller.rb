class SessionController < ApplicationController
	
	before_filter :parse_facebook_cookies, :except=>[:sigin]

	def parse_facebook_cookies
		@facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		session['fb_cookie'] = @facebook_cookies if @facebook_cookies.present?
	end

	def signin
		
	end

	
	def welcome
		@access_token = @facebook_cookies["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def super
		@access_token = @facebook_cookies["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@hero = @graph.get_object("me")
	end

	def logout
		session['fb_cookie'] = nil
    reset_session
    redirect_to root_url
	end
end
