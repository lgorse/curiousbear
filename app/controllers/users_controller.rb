class UsersController < ApplicationController
	include UsersHelper

	before_filter :authenticate, :except => [:create]
	before_filter :new_user_facebook, :only => [:create]


def create
end

def edit

end

def show
	respond_to do |format|
		format.html
		format.js
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
	@facebook_friends = @graph.get_connections("me", "friends", :fields => "name, id, picture")
	set_friend_lists
end

def following
	respond_to do |format|
		format.html
		format.js
	end
end

def followers
	respond_to do |format|
		format.html
		format.js
	end
end


end
