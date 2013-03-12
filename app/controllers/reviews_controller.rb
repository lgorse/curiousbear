class ReviewsController < ApplicationController
before_filter :authenticate

def new
	@user = @current_user
	@search = Base64.decode64(params[:search_field])
	@venue = JSON.parse(Base64.urlsafe_decode64(params[:venue_field]))
	@review = Review.new;
end

end
