class ApplicationController < ActionController::Base
	protect_from_forgery

	require 'net/http'
	require 'open-uri'
	include SessionHelper

end
