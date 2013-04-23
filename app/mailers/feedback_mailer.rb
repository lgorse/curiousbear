class FeedbackMailer < ActionMailer::Base
  default :from => ""
  default :to => "lgorse@stanford.edu"
  default :subject => "feedback about KweeKwegg"

  def send_feedback(message)
  	@message = message
  	mail(:from => message[:sender_email], :body => message[:body])

  end
end
