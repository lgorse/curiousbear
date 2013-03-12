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
#  google_reference  :string(255)
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
#

require 'spec_helper'

describe Restaurant do
  before(:each) do
  @user_attr = {:name => "Laurent Gorse", :first_name => "Laurent", :birthday => '1979-05-28'.to_date,
				:gender => "male", :e_mail => "lgorse@stanford.edu", :fb_id => 123456789}
	User.create!(@user_attr)
	@restaurant_attr = { :name => "restaurant", 
						:formatted_address => "Everywhere, Paris, France",
						:google_rating => 4.5, 
						:google_id => "xxx",
						:google_types => "restaurant, bar", 
						:google_reference => "xsdlgdg",
						:google_price => 2, 
						:lat => 0.45,
						:lng => 20.2
		}
		Restaurant.create!(@restaurant_attr)

	end
end
