module ReviewsHelper

	def set_review_attributes(review, restaurant_id, user_id)
		@attr = { 	:restaurant_id => restaurant_id,
					:user_id => user_id,
					:rating => review[:rating].to_d,
					:text => review[:text],
					:keywords => review[:keywords]
		}

	end
end
