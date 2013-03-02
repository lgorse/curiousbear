class ApplicationController < ActionController::Base
  protect_from_forgery

  def parse_facebook_cookies
		check_token_expiration
		session['fb_cookie'] ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		@access_token = session['fb_cookie']["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def check_token_expiration
		if session['fb_cookie'] != nil
			session.delete('fb_cookie') if token_expired?
		end
	end

	
	def token_expired?
		new_time = session[:fb_cookie]["expires"]
		Time.at(new_time.to_i) < Time.now
	end


end
