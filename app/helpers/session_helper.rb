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

	def parse_facebook_cookies
		check_token_expiration
		session['fb_cookie'] ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
		@access_token = session['fb_cookie']["access_token"]
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def check_token_expiration
		if session['fb_cookie'] != nil
			session['fb_cookie'] = nil if token_expired?
		end
	end

	
	def token_expired?
		new_time = session['fb_cookie']["expires"]
		Time.at(new_time.to_i) > Time.now
	end

	def redirect_to_signin
		redirect_to root_path
	end

	def set_session
		@user = User.find_by_fb_id(@me['id'])
		redirect_to register_path and return if @user.nil?
		session['user_id'] ||= @user.id
	end

	def authenticate
		parse_facebook_cookies
		set_session
	end

	def reset_user_session
		session['user_id'] = nil
		session['fb_cookie'] = nil
	end

end
