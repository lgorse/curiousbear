class FeedbackController < ApplicationController

	before_filter :authenticate, :except => [:send]

	def new
		
	end

	def send_feedback
		message_data = {:sender_email => params[:sender_email], :body => params[:body]}
		 if FeedbackMailer.send_feedback(message_data).deliver
      puts "SENT"
    else
      puts "FUCKUP"
    end
end
end
