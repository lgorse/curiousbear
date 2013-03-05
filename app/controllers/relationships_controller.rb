class RelationshipsController < ApplicationController

	def create
		@user = User.find(params[:user_id])
		@followed_id = params[:id]
		@user.follow!(@followed_id)
		respond_to do |format|
			format.html {redirect_to user_path(@user)}
			format.js 
		end
	end


	def destroy
		@user = User.find(params[:user_id])
		@followed_id = params[:id]
		@user.unfollow!(@followed_id)
		respond_to do |format|
			format.html {redirect_to user_path(@user)}
			format.js
		end
	end

end
