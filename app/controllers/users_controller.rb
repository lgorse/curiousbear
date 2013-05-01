class UsersController < ApplicationController
	include UsersHelper, ReviewsHelper

	rescue_from NoMethodError, :with => :redirect_to_signin, :only => [:facebook_friends]
	before_filter :authenticate, :except => [:create]
	before_filter :new_user_facebook, :only => [:create]


def create
end

def edit

end

def show
	#response.headers["Cache-Control"] = "no-cache, no-store, max-age=0"
	@user = User.find(params[:id])
	@user.update_photo(@graph)
	
	respond_to do |format|
		format.html 
		format.js 
		format.json {render :json => {:id => params[:id], :count => @user.reviews.count}}
	end
end

def update
	if @current_user.update_attributes(params[:user])
		redirect_to home_path
	else
		render 'edit'
	end
end

def destroy
	User.find(params[:id]).destroy
	delete_user_facebook
	reset_user_session
	redirect_to root_path
end

def facebook_friends
	@current_user.update_photo(@graph) unless @current_user.fb_pic
	@title = "Follow your friends"
	@user = @current_user
	@facebook_friends = @current_user.fb_friends_from_graph(@graph)
	@facebook_friends_invite, @facebook_friends_enrolled = @current_user.fb_friends_list(@facebook_friends)
	@stats =  Rails.cache.stats.first.last
	puts 'HITS: ' + @stats['get_hits']
	puts 'MISSES: ' + @stats['get_misses']
	@facebook_friends_invite.paginate(:page => params[:page], :per_page => 20)
	respond_to do |format|
		format.html
		format.js
		format.json {render :json => {:id => @current_user.id, :count => @facebook_friends.count}	}
	end
end

def following
	@user = User.find(params[:id])
	respond_to do |format|
		format.html
		format.js
	end
end

def followers
	@user = User.find(params[:id])
	respond_to do |format|
		format.html
		format.js
	end
end

def ip_address
	request.remote_ip
end



end
