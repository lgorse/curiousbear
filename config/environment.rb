# Load the rails application
require File.expand_path('../application', __FILE__)

# config/environment.rb
# in Rails::Initializer.run do |config|
config.action_controller.allow_forgery_protection = false
config.gem "koala"

# Initialize the rails application
Curiousbear::Application.initialize!
