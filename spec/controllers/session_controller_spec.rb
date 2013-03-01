require 'spec_helper'

describe SessionController do

	before(:each) do
		@test_users = Koala::Facebook::TestUsers.new(:app_id => Facebook::APP_ID.to_s, :secret => Facebook::SECRET.to_s)
		@user = @test_users.create(true,"read_stream, publish_stream")
		session['fb_cookie'] ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
	end

  describe "GET 'signin'" do
    it "returns http success" do
      get 'signin'
      response.should be_success
    end

  end

  describe "GET 'home'" do
  	it "returns http success" do
  	get 'home'
  	response.should redirect_to root_path
  end


  end


end
