module ReviewsHelper

	def set_review_attributes(review, restaurant_id, user_id)
		@attr = { 	:restaurant_id => restaurant_id,
					:user_id => user_id,
					:rating => review[:rating].to_d,
					:text => review[:text],
					:keywords => keywords_to_string(review[:keywords])
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

	def keywords_to_string(expression)
		get_wordstop_hash
		select_keywords = []
		expression.gsub(/[^A-Za-z]/, ' ').split.each {|word| select_keywords << word unless exempt_expressions(word)}
		return select_keywords.join(", ")
	end

	def set_wordstop_hash
		@hash = {}
		file = File.open("#{Rails.root}/app/assets/stopwords.txt")
		file.each do |line|
			key = line.chomp
			@hash[key] = ""
		end
		file.close
		Rails.cache.write('wordstop', @hash, :expire_in => 20.minutes)
		return @hash
	end

	def get_wordstop_hash
		@hash = Rails.cache.fetch('wordstop') {set_wordstop_hash} 
	end

	def exempt_expressions(word)
		@hash.has_key?(word) || 
		@restaurant.name.downcase.include?(word.downcase)|| 
		@restaurant.formatted_address.downcase.include?(word.downcase)
	end

	def reset_reviews_cache
		Rails.cache.delete('wordstop')
	end
end
