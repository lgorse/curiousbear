class RelationshipsController < ApplicationController
	include RelationshipsHelper

	
	def create
		@current_user = User.find(params[:current_user_id])
		@user = User.find(params[:user_id])
		@followed_id = params[:id]
		@current_user.follow!(@followed_id)
		respond_to do |format|
			format.html {redirect_to user_path(@user)}
			format.js 
		end
	end


	def destroy
		@current_user = User.find(params[:current_user_id])
		@user = User.find(params[:user_id])
		@followed_id = params[:id]
		@current_user.unfollow!(@followed_id)
		respond_to do |format|
			format.html {redirect_to user_path(@current_user)}
			format.js
		end
	end

end
