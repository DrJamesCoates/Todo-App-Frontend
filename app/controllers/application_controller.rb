class ApplicationController < ActionController::Base

  include Response
  include ExceptionHandler
  include SessionsHelper
  include HTTParty

  # check user logged in
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please login"
      store_location
      redirect_to login_url
    end
  end

  # orchestrate appropriate response when api error returned
  def api_error_response(object)
    flash[:danger] = object.response["message"] if object.response["message"]
    redirect_based_on_status_code(object.response.code)
  end
  
  def response_status_ok?(response)
    #successful show
    return true if response.code == 200
    #successful user create
    return true if response.code == 201
    #successful destroy
    return true if response.code == 204
    return false
  end

  def redirect_based_on_status_code(status_code)
    if status_code == 401
      log_out
      redirect_to login_url
    else
      redirect_to request.referrer
    end
  end
end
