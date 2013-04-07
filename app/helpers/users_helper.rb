module UsersHelper
	require 'will_paginate/array'

	def new_user_facebook
		if params['signed_request']
			signed_request = params['signed_request']
			@signed_request = decode_data(signed_request)
			@current_user_attributes = User.set_user_attributes(@signed_request)
			@current_user = User.where(:fb_id => @signed_request['user_id'].to_i).first_or_create!(@current_user_attributes)
			redirect_to root_path
		end
	end

	def delete_user_facebook
		url = URI.parse("https://graph.facebook.com/me/permissions?"+"access_token="+session["fb_cookie"]["access_token"])
		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Delete.new(url.request_uri)
		response = http.request(request)
	end

	def set_friend_lists
		@facebook_friends_invite = []
		@facebook_friends_enrolled = []
		@facebook_friends.reject{|profile| profile["id"] == @current_user.id}.
			sort_by{|profile| profile["name"]}.each do |profile|
			user = User.find_by_fb_id(profile["id"])
			user.nil? ? @facebook_friends_invite << profile : set_enrolled_fb_friend_list(user)
		end
		@facebook_invite_collection = @facebook_friends_invite.paginate(:page => params[:page], :per_page => 20)
	end

	def set_attr_from_fb(profile)
@attr = {:id => nil, :fb_pic => profile["picture"]["data"]["url"], :fb_id => profile["id"], :name => profile["name"]}
	end

	def set_enrolled_fb_friend_list(user)
		@facebook_friends_enrolled << user unless @current_user.following?(user)
	end

	
end
