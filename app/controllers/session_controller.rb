class SessionController < ApplicationController
	
	before_filter :parse_facebook_cookies, :except=>[:signin]

	def parse_facebook_cookies
		session['fb_cookie'] ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		 #= @facebook_cookies if @facebook_cookies.present?
	end

	def signin
		redirect_to welcome_path if session['fb_cookie'].present?
		
	end

	
	def welcome
		@access_token = session['fb_cookie']["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def super
		@access_token = session['fb_cookie']["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@hero = @graph.get_object("me")
	end

	def logout
		session['fb_cookie'] = nil
    reset_session
    redirect_to root_url
	end
end
