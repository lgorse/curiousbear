ThinkingSphinx::Index.define :restaurant, :with => :active_record, :delta => true do
	indexes formatted_address
	indexes :name
	indexes :keywords
	indexes reviews.keywords, :as => :review_keywords
	indexes reviews.text, :as => :review_text

	has reviews.user.id, :as => :reviewer_id
  #has reviews.rating, :as => :review_rating

end

def set_delta
	if Rails.env.production?
		FlyingSphinx::SidekiqDelta
	elsif Rails.env.development?
		ThinkingSphinx::Deltas::SidekiqDelta
	end
end