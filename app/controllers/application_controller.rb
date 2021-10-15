class ApplicationController < ActionController::Base

  include Response
  include ExceptionHandler
  include SessionsHelper
  include UsersHelper
  include TodosHelper

  include HTTParty

  BASE_REQUEST_URL = 'http://127.0.0.1:3000'

  def store_token(auth_token)
    session[:auth_token] = auth_token
  end

  def forget_token
    session.delete(:auth_token)
  end

end
