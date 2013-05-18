# == Schema Information
#
# Table name: walls
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Wall do
  
  before(:each) do
  @attr = {:name => "Laurent Gorse", :first_name => "Laurent", :birthday => '1979-05-28'.to_date,
        :gender => "male", :e_mail => "lgorse@stanford.edu", :fb_id => 123456789}
  @attr2 = {:name => "Peter Solace", :first_name => "Peter", :birthday => '1979-05-28'.to_date,
        :gender => "male", :e_mail => "pSolace@stanford.edu", :fb_id => 768954}
  end

  describe 'create the wall' do

     before(:each) do
      @user = User.create(@attr)
     end

  	it 'must be created automatically when a user is created' do
      @user.wall.should be_present
  	end

    it 'must be destroyed with the user it belongs to' do
      wall_id = @user.wall.id
      @user.destroy
      Wall.where(:id => wall_id).should_not be_present
    end

  	it 'must update to add a wall if the user did not have one before' do
      Wall.destroy(@user.wall)
      @user.update_attributes(@attr)
      User.find(@user.id).wall.should be_present
  	end

  end

  describe 'user' do
     before(:each) do
      @user = User.create(@attr)
     end

  	it 'should not allow a null user_id' do
      @wall = Wall.create(:user_id => nil)
      @wall.should_not be_valid
  	end


  	it 'should only have one user' do
      @user2 = User.create!(@attr2)
      @user2.wall.update_attributes(:user_id => @user.id)
      @user2.wall.should_not be_valid
  	end

  end

  describe 'posts' do

  end

end
