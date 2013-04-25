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


end
