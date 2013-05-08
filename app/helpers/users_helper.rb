module UsersHelper
	require 'will_paginate/array'

	def new_user_facebook
		if params['signed_request']
			signed_request = params['signed_request']
			@signed_request = decode_data(signed_request)
			@current_user_attributes = User.set_user_attributes(@signed_request)
			#debugger
			@current_user = User.where(:fb_id => @signed_request['user_id'].to_i).first_or_create!(@current_user_attributes)

			redirect_to root_path(:id => @current_user.id,:welcome => true)
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

	
	def set_attr_from_fb(profile)
@attr = {:id => nil, :fb_pic => profile['pic_square'],
		 :fb_id => profile["uid"], :name => profile["name"]}
	end

	def short_restaurant_list(user, limit_number)
		reviewer_list = user.reviews.limit(limit_number).collect {|review| link_to review.restaurant.name, review.restaurant}.join(" , ")
		simple_format word_wrap("Likes: " + reviewer_list)
	end

	
	
end
