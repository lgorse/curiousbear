# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Curiousbear::Application.initialize!

 ActionMailer::Base.smtp_settings = {
      :address => 'smtp.mandrillapp.com',
      :port => 587,
      :domain => 'heroku.com',
      :user_name => ENV['MANDRILL_USERNAME'],
      :password => ENV['MANDRILL_APIKEY'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }

 ActionMailer::Base.delivery_method = :smtp




