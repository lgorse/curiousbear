# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Relationship do

	before(:each) do
		@attr_follower = {:name => "Laurent Gorse", :first_name => "Laurent", :birthday => '1979-05-28'.to_date,
			:gender => "male", :e_mail => "lgorse@stanford.edu", :fb_id => 123456789}
		@attr_followed = {:name => "Peter Solace", :first_name => "Peter", :birthday => '1979-05-28'.to_date,
				:gender => "male", :e_mail => "pSolace@stanford.edu", :fb_id => 768954}
		@follower = User.create!(@attr_follower)
		@followed = User.create!(@attr_followed)
		@attr= {:followed_id => @followed.id}
	end

	describe "validations" do

		it "should require a follower id" do
			attribute = {:follower_id => nil, :followed_id => 2}
			Relationship.new(attribute).should_not be_valid
		end

		it "should require a followed id" do
			attribute = {:follower_id => 2, :followed_id => nil}
			Relationship.new(attribute).should_not be_valid

		end

	end

	describe "follow methods" do

		before (:each) do
			@relationship = @follower.relationships.create!(@attr)
		end

		it "should have a follower attribute" do
			@relationship.should respond_to(:follower)
		end

		it 'should have a followed attribute' do
			@relationship.should respond_to(:followed)

		end


	end
	
end

