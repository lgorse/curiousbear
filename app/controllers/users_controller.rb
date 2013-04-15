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
	response.headers["Cache-Control"] = "no-cache, no-store, max-age=0"
	@user = User.find(params[:id])
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
	@title = "Follow your friends"
	@user = @current_user
	@facebook_friends = @graph.fql_query('select uid, name, pic_square from user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY name ASC')
	
	set_friend_lists
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
