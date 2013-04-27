# == Schema Information
#
# Table name: activities
#
#  id         :integer          not null, primary key
#  feed_id    :integer          not null
#  user_id    :integer          not null
#  activity   :integer          not null
#  target_id  :integer
#  edgerank   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Activity < ActiveRecord::Base
	attr_accessible :activity, :edgerank, :target_id, :user_id, :feed_id
	belongs_to :user

	def self.create_follows(relationship_id)
		relationship = Relationship.find(relationship_id)
		user = User.find(relationship.follower_id)
		user.followers.each do |follower|
			Activity.create(:feed_id => follower.id, :user_id => relationship.follower.id, :target_id => relationship.followed.id, :activity => TRUST)
		end
	end

	def self.create_review(review_id)
		review = Review.find(review_id)
		review.user.followers.each do |follower|
			Activity.create(:feed_id => follower.id, :user_id => review.user.id, :target_id => review.restaurant.id, :activity => REVIEW)
		end
	end
end
