ThinkingSphinx::Index.define :restaurant, :with => :active_record, :delta => ThinkingSphinx::Deltas::SidekiqDelta do
	indexes formatted_address
	indexes :name
	indexes :keywords
	indexes reviews.keywords, :as => :review_keywords
	indexes reviews.text, :as => :review_text
	indexes :average

	has reviews.user.id, :as => :reviewer_id
 
  has average, :as => :rating_average

  has "RADIANS(restaurants.lat)", :as => :lat, :type => :float
  has "RADIANS(restaurants.lng)", :as => :lng, :type => :float

  group_by 'restaurants.lat', 'restaurants.lng'

  
end

