class ApplicationController < ActionController::Base

  include SessionsHelper
  include HTTParty

  HMAC_SECRET = "df09dcea68750666d1632f4cb6dc40856b003ab3ea111a8faa96ada57235c4d62998e40223455ab2dd6a5c861ad608d107632cef25b6f1a3454a3807ae8567c3"

  # check user logged in
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please login"
      store_location
      redirect_to login_url
    end
  end


  # orchestrate appropriate response when api error returned
  def api_error_response(object, request_referrer, old_object)
    flash[:danger] = object.response["message"] if object.response["message"]
    redirect_based_on_status_code(object, request_referrer, old_object)
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

  def redirect_based_on_status_code(object, request_referrer, old_object)
    if object.response.code == 401 || object.response["message"].match(/Signature expired/)
      log_out
      redirect_to login_url
    else
      @name = old_object.name if old_object == TodoApi::User
      @email = old_object.email if old_object == TodoApi::User
      @title = old_object.title if old_object == TodoApi::Todo
      @deadline = old_object.deadline if old_object == TodoApi::Todo
      @done = old_object.done if old_object == TodoApi::Item
      redirect_to request_referrer
    end
  end
end
