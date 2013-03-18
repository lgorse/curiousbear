module ReviewsHelper

	def set_review_attributes(review, restaurant_id, user_id)
		@attr = { 	:restaurant_id => restaurant_id,
					:user_id => user_id,
					:rating => review[:rating].to_d,
					:text => review[:text],
					:keywords => review[:keywords]
		}

	end

	def set_review_google_info(review)
		@reference = review.restaurant.google_reference
		@venue = get_restaurant_from_reference
		@lat = @venue["geometry"]["location"]["lat"]
		@lng = @venue["geometry"]["location"]["lng"]
		@map = {"lat" => @lat, "lng" => @lng, "reference" => @reference, "map_id" => review.id}
	end

	def average(entity)
		entity.reviews.average(:rating).to_s
	end
end
