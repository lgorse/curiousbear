class SessionController < ApplicationController
	

	APP_ID = "344309455673537"
	APP_SECRET="a01e34ab6ab6083c660c76adc56c9a8d"
	SITE_URL="http://127.0.0.1:3000/"

	def signin
		
	end

	def login
	
	end


	def welcome
		@facebook_cookies ||= Koala::Facebook::OAuth.new(APP_ID, APP_SECRET).get_user_info_from_cookie(cookies)
		@access_token = @facebook_cookies['access_token']
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def logout
	session['oauth'] = nil
    session['access_token'] = nil
    reset_session
    redirect_to root_url
	end
end
