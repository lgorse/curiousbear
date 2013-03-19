ThinkingSphinx::Index.define :restaurant, :with => :active_record do
  indexes formatted_address
  indexes :name
  indexes reviews.keywords, :as => :review_keywords
  indexes reviews.text, :as => :review_text

  has reviews.user.id, :as => :reviewer_id
  #has reviews.rating, :as => :review_rating

end

