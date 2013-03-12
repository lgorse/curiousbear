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

require 'spec_helper'

describe Reviews do
  pending "add some examples to (or delete) #{__FILE__}"
end
