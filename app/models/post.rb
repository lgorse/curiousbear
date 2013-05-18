# == Schema Information
#
# Table name: posts
#
#  id              :integer          not null, primary key
#  poster_id       :integer          not null
#  post_text       :text
#  recommendations :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Post < ActiveRecord::Base
  attr_accessible :post_text, :user_id, :recommendations
  validates :user_id, :presence => true
  validates :post_text, :presence => true

  belongs_to :user


  def send_to_friends(user)

  end
end
