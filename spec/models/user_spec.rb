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
#  fb_pic     :string(255)
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

		

	end

	describe "following" do
		before(:each) do
			@attr_follower = {:name => "Laurent Gorse", :first_name => "Laurent", :birthday => '1979-05-28'.to_date,
				:gender => "male", :e_mail => "lgorse@stanford.edu", :fb_id => 123456789}
  			@attr_followed = {:name => "Peter Solace", :first_name => "Peter", :birthday => '1979-05-28'.to_date,
				:gender => "male", :e_mail => "pSolace@stanford.edu", :fb_id => 768954}
			@follower = User.create!(@attr_follower)
			@followed = User.create!(@attr_followed)
		end

		describe "follow a user" do

			it "should have a following method" do
				@follower.should respond_to(:following)
			end

			it "should have a follow! method" do
				@follower.should respond_to(:follow!)
			end


			it "should include the new followed user in the followed_users array" do
				@follower.follow!(@followed.id)
				@follower.following.should include (@followed)

			end

			it "should be following the other user" do
				@follower.follow!(@followed.id)
				@follower.should be_following(@followed)

			end

		end

		describe "unfollow a user" do

			it "should have an unfollow! method" do
				@follower.should respond_to(:unfollow!)

			end

			it "should unfollow a user" do
				@follower.follow!(@followed.id)
				@follower.unfollow!(@followed)
				@follower.should_not be_following(@followed)

			end

			it "should not include the followed user in the followed_users array" do
				@follower.follow!(@followed.id)
				@follower.unfollow!(@followed)
				@follower.following.should_not include (@followed)
				end

		end

	end

  
end
