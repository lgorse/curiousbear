# == Schema Information
#
# Table name: walls
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Wall < ActiveRecord::Base
  attr_accessible :user_id
  validates :user_id, :presence => true, :uniqueness => true

  belongs_to :user
end
