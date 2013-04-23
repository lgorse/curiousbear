class FeedbackController < ApplicationController

	before_filter :authenticate, :except => [:send]

	def new
		respond_to do |format|
			format.html
			format.js 
		end 
	end

	def send_feedback
		message_data = {:sender_email => params[:sender_email], :body => params[:body]}
		if FeedbackMailer.send_feedback(message_data).deliver
			puts "FEEDBACK SENT"
		else
			puts "FEEDBACK FAIL"
		end
		redirect_to edit_user_path(session['user_id'])
	end
end
