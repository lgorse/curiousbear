# == Schema Information
#
# Table name: restaurants
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  google_photo      :string(255)
#  google_price      :integer
#  google_rating     :float
#  lat               :float
#  lng               :float
#  google_id         :string(255)      not null
#  google_reference  :text
#  keywords          :text
#  google_types      :text             default("restaurant, establishment, food")
#  formatted_address :string(255)
#  street_number     :string(255)
#  street            :string(255)
#  city              :string(255)
#  admin_area        :string(255)
#  zip               :string(255)
#  country           :string(255)
#  phone             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  delta             :boolean          default(TRUE), not null
#  average           :integer          default(0)
#

class Restaurant < ActiveRecord::Base
	include Sidekiq::Worker
	
	attr_protected
	validates :google_id, :uniqueness => {:message => "already exists"}
	has_many :reviews, :dependent => :destroy

	def self.trust_search(query, user)
		
		#user = User.find(78) #This line a hack for development environment
		#user.update_attributes(:ip_address => "128.12.187.157") #This line a hack for development environment
		
		reviewer_list = user.following.collect {|friend| friend.id}
		@lat = Geocoder::Calculations.to_radians(user.lat)
		@long = Geocoder::Calculations.to_radians(user.long)
		Restaurant.search(query, :geo => [@lat, @long],
								 :with => {:reviewer_id => reviewer_list << user.id},
								 :order => "rating_average DESC, geodist ASC")
	end

	def self.update_keywords
		Restaurant.all.each do |restaurant|
			word_array = Hash.new(0)
			restaurant.reviews.each do |review|
				review_keywords = review.keywords.split(',')		
				review_keywords.each{|word| word_array[word.strip] += 1} if review_keywords.length > 0
			end
			if word_array.length > 0
				word_array.sort_by{|key, value| value}.reverse!
				puts word_array_to_string = word_array.keys[0..5].join(', ')
				restaurant.update_attributes(:keywords => word_array_to_string)
			end
		end

	end

	def set_average
		self.update_attributes(:average => self.reviews.average(:rating).to_i)
	end
	
end
