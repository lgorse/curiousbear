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
			if session['fb_cookie'].blank?
				redirect_to 'http://www.cnn.com'
			else
				@access_token = session['fb_cookie']["access_token"]
			end
		rescue Koala::Facebook::OAuthTokenRequestError
			session['fb_cookie'] = nil
			set_access_token
		end

	end

	def set_facebook_graph
		@graph = Koala::Facebook::GraphAPI.new(@access_token)
		@me = @graph.get_object("me")
	end

	def set_user_picture
		@current_user.update_attributes(:fb_pic => @graph.get_picture("me")) if @current_user.fb_pic.nil?
		@current_user.update_attributes(:fb_pic_large => @graph.get_picture("me", :type => "normal")) if @current_user.fb_pic_large.nil?
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

	def set_session
		@current_user = User.find_by_fb_id(@me['id'])
		redirect_to register_path and return if @current_user.nil?
		session['user_id'] ||= @current_user.id
	end

	def parse_facebook_cookies
		check_token_expiration
		set_access_token
		set_facebook_graph
	end

	def authenticate
		parse_facebook_cookies
		set_session
		set_user_picture
	end

	def reset_user_session
		session['user_id'] = nil
		session['fb_cookie'] = nil
		cookies.delete(:profile_pic)
		reset_session
	end

end
