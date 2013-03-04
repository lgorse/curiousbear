class RelationshipsController < ApplicationController

	before_filter :authenticate

	def create
		@followed = User.find_by_id(params[:followed_id])
		@user.follow!(params[:followed_id])
		respond_to do |format|
			format.html {redirect_to user_path(@user)}
			format.js
		end
	end


	def destroy
		@followed = User.find_by_id(params[:id])
		@user.unfollow!(params[:id])
		respond_to do |format|
			format.html {redirect_to user_path(@user)}
			format.js
		end
	end

end
