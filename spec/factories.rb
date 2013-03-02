FactoryGirl.define do

	factory :user do |user|
		user.name = "Laurent Gorse"
		user.first_name = "Laurent"
		user.birthday = '1979-05-28'.to_date
		user.gender = "male"
		user.e_mail = "lgorse@stanford.edu"
		user.fb_id = 12344654
	end

end