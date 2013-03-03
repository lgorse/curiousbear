# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  first_name :string(255)
#  birthday   :date             not null
#  gender     :string(255)
#  e_mail     :string(255)
#  fb_id      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	attr_accessible :birthday, :e_mail, :fb_id, :first_name, :gender, :name

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


	def self.set_user_attributes(signed_request)
		@attr = {:name => signed_request['registration']['name'], :first_name => signed_request['registration']['first_name'],
			:birthday => Date.strptime(signed_request['registration']['birthday'], '%m/%d/%Y'), :gender => signed_request['registration']['gender'],
			:e_mail => signed_request['registration']['email'], :fb_id => signed_request['user_id'].to_i}
	end

	def follow!(followed)
		self.relationships.create!(:followed_id => followed.id)
	end

	def unfollow!(followed)
		self.relationships.find_by_followed_id(followed).destroy
	end

	def following?(followed)
		self.relationships.find_by_followed_id(followed)
	end

end