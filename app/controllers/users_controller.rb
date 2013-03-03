class UsersController < ApplicationController
	include UsersHelper

	before_filter :authenticate, :except => [:create]
	before_filter :new_user_facebook, :only => [:create]


def create
end

def edit

end

def show
end

def update
	if @user.update_attributes(params[:user])
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
	@friends = @graph.get_connections("me", "friends")

end

end
