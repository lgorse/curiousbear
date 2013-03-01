class SessionController < ApplicationController
	
	before_filter :parse_facebook_cookies, :only=>[:welcome]

	APP_ID = "344309455673537"
	APP_SECRET="a01e34ab6ab6083c660c76adc56c9a8d"
	SITE_URL="http://127.0.0.1:3000/"

	def parse_facebook_cookies
		facebook_cookies ||= Koala::Facebook::OAuth.new(APP_ID, APP_SECRET).get_user_info_from_cookie(cookies)
		session[:fb_cookie] = facebook_cookies if facebook_cookies.present?
	end

	def signin
		
	end

	
	def welcome
		@access_token = session[:fb_cookie]["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def super
		@access_token = session[:fb_cookie]["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@hero = @graph.get_object("me")
    	
	end
end
