class SessionController < ApplicationController
	include UsersHelper, ReviewsHelper
	
	#rescue_from NoMethodError, :with => :redirect_to_signin
	rescue_from Koala::Facebook::AuthenticationError, :with => :logout
	before_filter :authenticate, :only=>[:home]
	after_filter :reset_user_session, :only=>[:signin]
	
	def signin


	end

	def register

	end

	
	#Note the second User.find according to session => otherwise there is a dump format
	# error in the app, only on the home controller action
	def home
		@current_user.update_photo(@graph)
		@best_restaurants = Restaurant.top_5_by_rating(@current_user)
		@shared_friends = User.find(session['user_id']).top_5_by_shared_friends
	@popular = @current_user.top_5_by_followers.reject{|user| @shared_friends.include?(user)}
		respond_to do |format|
			format.html
			format.js
		end 
		
	end

	
	def logout
		reset_reviews_cache
		reset_user_session
		redirect_to root_path
	end

	def info
		if session["user_id"]
		authenticate 
		fb_friends = @graph.get_connections("me", "friends", :fields => "picture", :limit => 5)
		@five_friends = fb_friends.map{|fb_friend| fb_friend['picture']['data']['url']}
	else
		@current_user = User.find_by_name("Laurent Gorse")
		trusted_friends = @current_user.following.limit(5)
		@five_friends = trusted_friends.map{|trusted_friend| trusted_friend.fb_pic}
	end
		respond_to do |format|
			format.html
			format.js
		end 
	end
	

	
end
