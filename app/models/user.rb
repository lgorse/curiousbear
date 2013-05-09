# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  first_name   :string(255)
#  birthday     :date             not null
#  gender       :string(255)
#  e_mail       :string(255)
#  fb_id        :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  fb_pic       :string(255)
#  fb_pic_large :string(255)
#  price        :decimal(, )
#  lat          :float
#  long         :float
#  ip_address   :string(255)
#

class User < ActiveRecord::Base
	extend ::Geocoder::Model::ActiveRecord
	attr_accessible :birthday, :e_mail, :fb_id, :first_name, :gender, :name, :fb_pic, :fb_pic_large, :ip_address, :lat, :long

	email_format = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :name, :presence => true
	validates :birthday, :presence => true
	validates :fb_id, :presence => true
	validates :first_name, :length => {:maximum => 50}
	validates :e_mail, :format => {:with => email_format}, :uniqueness => {:case_sensitive => false}

	has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
	has_many :reverse_relationships, :foreign_key => "followed_id", :dependent => :destroy, :class_name => "Relationship"
	has_many :following,  :through => :relationships, :source => :followed
	has_many :followers, :through => :reverse_relationships, :source => :follower

	has_many :reviews, :dependent => :destroy

	has_many :restaurants, :through => :reviews

	has_one :activity, :dependent => :destroy

	geocoded_by :ip_address, :latitude => :lat, :longitude => :long
	after_validation :geocode


	def self.set_user_attributes(signed_request)
		@attr = {:name => signed_request['registration']['name'], :first_name => signed_request['registration']['first_name'],
			:birthday => Date.strptime(signed_request['registration']['birthday'], '%m/%d/%Y'), :gender => signed_request['registration']['gender'],
			:e_mail => signed_request['registration']['email'], :fb_id => signed_request['user_id'].to_i}
		end

		def follow!(followed_id)
			self.relationships.create!(:followed_id => followed_id)
		end

		def unfollow!(followed)
			self.relationships.find_by_followed_id(followed).destroy
		end

		def following?(followed)
			self.relationships.find_by_followed_id(followed)
		end

		def gender_article
			if self.gender == "male"
				articles = {"subject" => "he", "possess" => "his", "object" => "him"}
			elsif self.gender == "female"
				articles = {"subject" => "her", "possess" => "her", "object" => "her"}
			end
		end

		def update_photo(graph)
			self.update_attributes(:fb_pic => graph.get_picture(self.fb_id),
				:fb_pic_large => graph.get_picture(self.fb_id, :type => "normal"))
		end

		def get_user_small_pic(graph)
			self.fb_pic||=self.update_photo(graph)
		end

		def has_rated?(restaurant_id)
			self.reviews.where(:restaurant_id => restaurant_id).exists?
		end

		def rating(restaurant_id)
			review = self.reviews.find_by_restaurant_id(restaurant_id)
			review ? review.rating : 0
		end

		def feed
			Activity.where(:feed_id => self.id).order('created_at DESC').limit(30)
		end

		def fb_friends_from_graph(graph)
			Rails.cache.fetch('fb_friends_graph'){set_friends_list_from_graph(graph)}
		end

		def fb_friends_list(facebook_friends)
			Rails.cache.fetch('fb_friends_list'){set_friends_list(facebook_friends)}
		end


		def set_friends_list_from_graph(graph)
			facebook_friends = graph.fql_query('select uid, name, pic_square from user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY name ASC')
		end

		def set_friends_list(facebook_friends)
			facebook_friends_invite = []
			facebook_friends_enrolled = []
			facebook_friends.each do |profile|
				user = User.find_by_fb_id(profile["uid"]) unless profile["uid"] == self.id
				user.nil? ? facebook_friends_invite << profile : facebook_friends_enrolled << user unless self.following?(user)
			end
			[facebook_friends_invite, facebook_friends_enrolled]
		end

		def common_friends(user)
			(self.following && user.following).count
		end

		

		def top_5_by_reviews
			
			User.joins('left join reviews on reviews.user_id = users.id').where('users.id != ?', self.id).
			select('users.*, count(reviews.id) as reviews_count').
			group('users.id').order('reviews_count DESC').
			reject{|user| self.following.include?(user)}.first(5)
		end

		def top_5_by_followers
			User.order('(select count(1) from relationships inner join users on relationships.follower_id = users.id where users.id = relationships.followed_id)').
			where('users.id != ?', self.id).
			reject{|user| self.following.include?(user)}.first(5)
		end

	end
