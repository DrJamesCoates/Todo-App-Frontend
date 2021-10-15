class SessionsController < ApplicationController

  before_action :logged_in?, only: :destroy

  def new
  end

  def create
    response = get_user(user_login_params)
    response_object = JSON.parse(response.body, symbolize_names: true)
    # require 'pry'; binding.pry
    if status = 200
      log_in(response_object[:user_id])
      store_token(response_object[:auth_token])
      redirect_to user_url(response_object[:user_id])
    else
      flash.now[:danger] = "Could not login"
      render 'static_pages/home'
    end
  end

  def destroy
    log_out
    forget_token
    redirect_to root_url
  end

  private

    def user_login_params
      params.permit(:email, :password)
    end
end
