class ReviewsController < ApplicationController
	include RestaurantsHelper, ReviewsHelper

	before_filter :authenticate, :except => [:index]

	def index
		@user = User.find(params[:user_id])
		@current_user = User.find(session['user_id'])
	end

	def new
		@search = Base64.decode64(params[:search_field])
		@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:venue_field])))
		@review = Review.new	
	end

	def create
		@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:review][:venue])))
		@restaurant = Restaurant.find_or_create_by_google_id(@venue["google_id"], final_restaurant_attributes(@venue))
		@attr = set_review_attributes(params[:review], @restaurant.id, @current_user.id)
		if @review = Review.create(@attr)
			flash[:success] = "Review saved. Share with friends!"
		else
			flash[:error] = @review.errors.full_messages.to_sentence
		end

		respond_to do |format|
			format.html {redirect_to @restaurant}
			format.js 
			format.json {render :json => @review}

		end
	end

	def edit
		@review = Review.find(params[:id])
		@restaurant = Restaurant.find(@review.restaurant_id)
	end

	def update
		@review = Review.find(params[:id])
		@restaurant = Restaurant.find(@review.restaurant_id)
		@attr = set_review_attributes(params[:review], @restaurant.id, @current_user.id)
		if @review.update_attributes(@attr)
			flash[:success] = "Review updated"
		else
			flash.now[:error] = @review.errors.full_messages.to_sentence
		end
		respond_to do |format|
			format.html 
			format.js 
		end
	end

	def destroy
		@review = Review.find(params[:id])
		@restaurant = Restaurant.find(@review.restaurant_id)
		@review.destroy
		redirect_to restaurant_path(@restaurant)
	end

	def rate
		@review = Review.find(params[:id])
		@review.update_attributes(params[:review])
		render :nothing => true
	end

end
