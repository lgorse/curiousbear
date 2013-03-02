class UserController < ApplicationController
	include UserHelper
	include SessionHelper

	before_filter :authenticate, :except => [:create]
	before_filter :new_user_facebook, :only => [:create]

def create
end

def edit

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
	redirect_to logout_path
end

end
