source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'annotate'
gem 'will_paginate'
gem 'koala'
gem "google_places"
gem "mysql2", '~> 0.3.12b5'
gem "thinking-sphinx"
gem "oink"
gem 'newrelic_rpm'
gem 'fancybox2-rails', '~> 0.2.4'
gem "geocoder"




# Gems used only for assets and not required
# in production environments by default.
group :assets do
	gem 'sass-rails',   '~> 3.2.3'
	gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development do
	gem 'rspec-rails'
	gem 'autotest'
	gem 'faker'
	gem 'annotate'
	gem 'factory_girl_rails', :require => false
end

group :test do
	gem 'rspec-rails'
	gem 'factory_girl_rails'
	gem 'capybara'
end

group :production do
	gem 'pusher-client',
	:git    => 'git://github.com/pat/pusher-ruby-client.git',
	:branch => 'catch-io',
	:ref    => '608cc28d1a'
	gem 'flying-sphinx',
	:git    => 'git://github.com/flying-sphinx/flying-sphinx.git',
	:branch => 'master',
	:ref    => 'e1395e724a'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
