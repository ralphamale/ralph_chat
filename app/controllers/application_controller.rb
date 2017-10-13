class ApplicationController < ActionController::Base
  # For APIs, we use null_session
  protect_from_forgery with: :null_session

  include Authenticable
end
