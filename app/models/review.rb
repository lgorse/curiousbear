# == Schema Information
#
# Table name: reviews
#
#  id            :integer          not null, primary key
#  restaurant_id :integer          not null
#  user_id       :integer          not null
#  rating        :decimal(2, 1)
#  text          :text
#  keywords      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Review < ActiveRecord::Base
  attr_accessible :keywords, :rating, :restaurant_id, :text, :user_id
  belongs_to :restaurant 
  belongs_to :user

  
end
