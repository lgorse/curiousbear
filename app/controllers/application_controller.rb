class ApplicationController < ActionController::Base
	protect_from_forgery

	require 'net/http'
	include SessionHelper

end
