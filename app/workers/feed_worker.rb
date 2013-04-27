class FeedWorker
	include Sidekiq::Worker

	def perform(id, type)
		case type
		when REVIEW
			Activity.create_review(id)
		when TRUST
			Activity.create_follows(id)
		end
	end
end