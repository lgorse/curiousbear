module ReviewsHelper

	def set_review_attributes(review, restaurant_id, user_id)
		

	end

	def set_review_google_info(review)
		@map = {"lat" => review.restaurant.lat, "lng" => review.restaurant.lng, 
				"reference" => review.restaurant.google_reference, "map_id" => review.id}
	end

	def average(entity)
		entity.reviews.average(:rating).to_i
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

	def encode_venue_google_id(google_id)
		google_id_json = {"google_id" => google_id}.to_json
		encoded_google_id_json = Base64.urlsafe_encode64(URI.encode(google_id_json))
	end

end
