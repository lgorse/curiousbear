class ReviewsController < ApplicationController
before_filter :authenticate

def new
	@user = @current_user
	@restaurant_google_id = params[:google_id]
	@restaurant_attr = params[:attr]
end

end
