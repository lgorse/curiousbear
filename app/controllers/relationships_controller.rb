class RelationshipsController < ApplicationController

	before_filter :authenticate

	def create
		@followed = User.find_by_id(params[:id])
		@user.follow!(params[:id])
		@id = params[:id]
		respond_to do |format|
			format.html {redirect_to user_path(@user)}
			format.js 
		end
	end


	def destroy
		@followed = User.find_by_id(params[:id])
		@user.unfollow!(params[:id])
		@id = params[:id]
		respond_to do |format|
			format.html {redirect_to user_path(@user)}
			format.js
		end
	end

end
