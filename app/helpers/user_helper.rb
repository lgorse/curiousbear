module UserHelper

	def new_user_facebook
		if params['signed_request']
			signed_request = params['signed_request']
			@signed_request = decode_data(signed_request)
			@user_attributes = User.set_user_attributes(@signed_request)
			@user = User.where(:fb_id => @signed_request['user_id'].to_i).first_or_create!(@user_attributes)
			redirect_to root_path
		end
	end

end
