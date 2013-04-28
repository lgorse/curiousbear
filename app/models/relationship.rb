# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Relationship < ActiveRecord::Base
	attr_accessible :followed_id, :follower_id

	belongs_to :follower, :foreign_key => "follower_id", :class_name => "User"
	belongs_to :followed, :foreign_key => "followed_id", :class_name => "User"

	validates :follower_id, :presence => true
	validates :followed_id, :presence => true

	after_commit :new_relationship_in_feed, :on => :create

	after_create :expire_fb_friends_cache
	after_destroy :expire_fb_friends_cache


	private

	def new_relationship_in_feed
		FeedWorker.perform_async(self.id, TRUST)
	end

	def expire_fb_friends_cache
		Rails.cache.delete('fb_friends_list')
	end
end
