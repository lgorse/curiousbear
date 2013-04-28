module ActivitiesHelper

def set_feed_activity(item)
	case item.activity
	when TRUST
		@feed_user = User.find_by_id(item.user_id)
		@feed_activity = "is following "
		@feed_target = User.find_by_id(item.target_id)
		when REVIEW
			@feed_user = User.find_by_id(item.user_id)
			@feed_activity = "has reviewed "
		@feed_target = Restaurant.find_by_id(item.target_id)
	end

end


def you_or_name
	@feed_target == @current_user ? "you" : @feed_target.name
	end

end
