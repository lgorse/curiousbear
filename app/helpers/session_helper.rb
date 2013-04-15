module SessionHelper

	def base64_url_decode str
		encoded_str = str.gsub('-','+').gsub('_','/')
		encoded_str += '=' while !(encoded_str.size % 4).zero?
		Base64.decode64(encoded_str)
	end

	def decode_data str
		encoded_sig, payload = str.split('.')
		data = ActiveSupport::JSON.decode base64_url_decode(payload)
	end

	
	def set_access_token
		begin
			session['fb_cookie'] ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
			@access_token = session['fb_cookie']["access_token"]
		rescue Koala::Facebook::OAuthTokenRequestError
			session['fb_cookie'] = nil
			set_access_token
		end

	end

	def set_facebook_graph
		@graph = Koala::Facebook::API.new(@access_token)
		@me = @graph.get_object("me")
	end

	def check_token_expiration
		if session['fb_cookie']
			session['fb_cookie'] = nil if token_expired?
		end
	end

	def token_expired?
		Time.now.to_i - session['fb_cookie']['issued_at'].to_i >= session['fb_cookie']["expires"].to_i
	end

	def redirect_to_signin
		redirect_to root_path
	end

	def parse_facebook_cookies
		check_token_expiration
		set_access_token
		set_facebook_graph
	end

	def set_session
		@current_user = User.find_by_fb_id(@me['id'])
		if @current_user.nil? #this catches the error where the user has authorized the app but somehow disappeared from our db
			delete_user_facebook
			redirect_to register_path and return 
		end
		session['user_id'] ||= @current_user.id
	end

	

	def authenticate
		parse_facebook_cookies
		set_session
		@current_user.update_attributes_for_session(@graph, request)
	end

	def reset_user_session
		session['user_id'] = nil
		session['fb_cookie'] = nil
		cookies.delete(:profile_pic)
		cookies.delete(:first_entry)
		reset_session
	end

end
