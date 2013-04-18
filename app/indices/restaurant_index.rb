ThinkingSphinx::Index.define :restaurant, :with => :active_record, :delta => :set_delta do
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
	FlyingSphinx::DelayedDelta
elsif Rails.env.development?
	ThinkingSphinx::Deltas::DelayedDelta
end
end