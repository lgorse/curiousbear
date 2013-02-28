class SessionController < ApplicationController
	

	APP_ID = "344309455673537"
	APP_SECRET="a01e34ab6ab6083c660c76adc56c9a8d"
	SITE_URL="http://127.0.0.1:3000/"

	def signin
		
	end

	def login
		session['oauth'] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + '/welcome')
		redirect_to session['oauth'].url_for_oauth_code()
	end


	def welcome
		session['access_token'] = session['oauth'].get_access_token(params[:code])
		@access_token = session['access_token']
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def logout
	session['oauth'] = nil
    session['access_token'] = nil
    redirect_to root_path
	end
end
