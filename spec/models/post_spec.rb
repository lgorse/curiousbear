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

	require 'spec_helper'

	describe Post do
		before(:each) do
		@attr = {:name => "Laurent Gorse", :first_name => "Laurent", :birthday => '1979-05-28'.to_date,
					:gender => "male", :e_mail => "lgorse@stanford.edu", :fb_id => 123456789}
		@attr2 = {:name => "Peter Solace", :first_name => "Peter", :birthday => '1979-05-28'.to_date,
					:gender => "male", :e_mail => "pSolace@stanford.edu", :fb_id => 768954}
		end
	  
	  describe "validations" do
	  	before(:each) do
	  		@user = User.create!(@attr)
	  	end

	  	it "should not allow a null poster_id" do
	  		@post = Post.new(:user_id => nil, :post_text => "Hello")
	  		@post.should_not be_valid

	  	end

	  	it "should not allow blank text" do
	  		@post = Post.new(:user_id => @user.id, :post_text => nil)
	  		@post.should_not be_valid
	  	end

	  	it "should remove all posts when a user is deleted" do
	  		@post = Post.create(:user_id => @user.id, :post_text => "hello")
	  		@user.destroy
	  		Post.where(:id => @post.id).should_not be_present
	  	end

	  end

	  describe "when on a wall" do
	  	before(:each) do
	  		@user = User.create!(@attr)
	  		@post = Post.create!(:user_id => @user.id, :post_text => "Hello")
	  		@user2 = User.create(@attr2)
	  		@user.follow!(@user2.id)
	  	end

	  	it "should belong to many walls" do
	  		
	  		@post.send_to_friends(@user)
	  		@user2.wall.posts.should include @post

	  	end

	  	it "should remove the post from all walls when deleted" do
	  			@post.send_to_friends(@user)
	  			@post.destroy
	  			@user2.wall.posts.should_not include @post
	  	end

	  end

	  describe "recommendations" do

	  	it "should allow recommendations" do

	  	end

	  	it "should allow multiple recommendations" do

	  	end

	  end
	end
