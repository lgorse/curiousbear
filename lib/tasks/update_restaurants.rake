desc "this task updates the restaurant keywords"
namespace :restaurant do
	task :update_keywords => :environment do
		Restaurant.update_keywords
	end

	task :update_average => :environment do
		Restaurant.all.each {|restaurant| restaurant.set_average }
	end

end