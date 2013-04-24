desc "this task updates the restaurant keywords"
namespace :restaurant do
	task :update_keywords => :environment do
		Restaurant.update_keywords
	end

end