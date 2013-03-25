class ReviewsController < ApplicationController
	include RestaurantsHelper, ReviewsHelper

	before_filter :authenticate, :except => [:index]

	def index
	
		@user = User.find(params[:id])
		@current_user = User.find(session['user_id'])
		@reviews = @user.reviews.paginate(:page => params[:page], :per_page => 5)
		render :partial => 'reviews/user_reviews'
	end

	def new
		@search = Base64.decode64(params[:search_field])
		@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:venue_field])))
		@restaurant = Restaurant.find_or_create_by_google_id(@venue["google_id"], final_restaurant_attributes(@venue))
		@review = Review.new	
	end

	def create
		if params[:review][:venue].present?
		@venue = JSON.parse(URI.decode(Base64.urlsafe_decode64(params[:review][:venue])))
		@restaurant = Restaurant.find_or_create_by_google_id(@venue["google_id"], final_restaurant_attributes(@venue))
	else
		@restaurant = Restaurant.find(params[:review][:restaurant_id])
	end
		params[:review][:keywords] = (keywords_to_string(params[:review][:keywords])) if params[:review][:keywords]
		if @review = Review.create(params[:review].merge(:restaurant_id => @restaurant.id, :user_id => @current_user.id).except(:venue))
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
		params[:review][:keywords] = (keywords_to_string(params[:review][:keywords])) if params[:review][:keywords]
		if @review.update_attributes(params[:review].merge(:restaurant_id => @restaurant.id, :user_id => @current_user.id).except(:venue))
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

end
