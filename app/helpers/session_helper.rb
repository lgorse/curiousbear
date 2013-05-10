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
		session["fb_graph"] ||= Koala::Facebook::API.new(@access_token)
		@graph = session["fb_graph"]
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
		session['user_id'] ||= User.find_by_fb_id(@graph.get_object("me")['id'])
		@current_user = session['user_id']
		if @current_user.nil? #this catches the error where the user has authorized the app but somehow disappeared from our db
			delete_user_facebook
			redirect_to register_path and return 
		end
		
	end


	def set_remote_ip
		@current_user.update_attributes(:ip_address => request.remote_ip) unless @current_user.ip_address == request.remote_ip

	end

	def authenticate
		parse_facebook_cookies
		set_session
		set_remote_ip
	end

	def reset_user_session
		session['user_id'] = nil
		session['fb_cookie'] = nil
		cookies.delete(:profile_pic)
		reset_session
		Rails.cache.clear
	end

	def no_header_pages
		(controller_name == 'session' && action_name == 'info') ||
		(controller_name == 'feedback' && action_name == 'new')

	end

end
