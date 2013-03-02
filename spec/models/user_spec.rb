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

require 'spec_helper'

describe User do

	before(:each) do
	@attr = {:name => "Laurent Gorse", :first_name => "Laurent", :birthday => '1979-05-28'.to_date,
				:gender => "male", :e_mail => "lgorse@stanford.edu", :fb_id => 123456789}
	end

	describe 'create user' do

		describe 'invalid user' do

			it "should refuse a user without a name" do
				user = User.new(@attr.merge(:name=>""))
				user.should_not be_valid
			end

			it "should refuse a user without a birthday" do
				user = User.new(@attr.merge(:birthday =>""))
				user.should_not be_valid
			end

			it "should refuse a user without a facebook ID" do
				user = User.new(@attr.merge(:fb_id => ""))
				user.should_not be_valid
			end

			it "should refuse a first name that is too long" do
				name = "a" * 72
				user = User.new(@attr.merge(:first_name => name))
				user.should_not be_valid
			end

			it "should reject invalid email addresses" do
				addresses = ["user@super,hello", "user_at.cool.org", "user@super."]
				addresses.each do |address|
					user = User.new(@attr.merge(:e_mail => address))
					user.should_not be_valid
				end


			end

			it "should reject duplicate email addresses" do
				user = User.create(@attr)
				new_user = User.new(@attr)
				new_user.should_not be_valid

			end

			it "should reject upcased duplicate email addresses" do
				address = @attr[:e_mail].upcase
				user = User.create!(@attr)
				upcased_user = User.new(@attr.merge(:e_mail => address))
				upcased_user.should_not be_valid



			end
			

		end

		describe 'valid order' do

		end

	end

  
end
