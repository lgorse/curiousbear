# == Schema Information
#
# Table name: reviews
#
#  id            :integer          not null, primary key
#  restaurant_id :integer          not null
#  user_id       :integer          not null
#  rating        :integer
#  text          :text
#  keywords      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Review < ActiveRecord::Base
  attr_accessible :keywords, :rating, :restaurant_id, :text, :user_id
  belongs_to :restaurant 
  belongs_to :user

  validates :user_id, :presence => true
  validates :restaurant_id, :presence => true
  validates :user_id, :uniqueness => {:scope => :restaurant_id, :message => "already reviewed this restaurant"}
  validates_numericality_of :rating, :greater_than => 0

  default_scope :order => 'rating DESC, id'

  after_save :set_restaurant_delta_flag
  after_destroy :set_restaurant_delta_flag

  private

  def set_restaurant_delta_flag
    
  	restaurant.delta = true
  	restaurant.save
  end

  
end
