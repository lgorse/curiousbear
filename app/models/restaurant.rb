# == Schema Information
#
# Table name: restaurants
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  google_photo      :string(255)
#  google_price      :integer
#  google_rating     :integer
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

class Restaurant < ActiveRecord::Base
 attr_protected
end
