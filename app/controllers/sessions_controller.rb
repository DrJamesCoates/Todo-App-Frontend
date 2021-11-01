class SessionsController < ApplicationController

  before_action :logged_in_user, only: :destroy

  def new
  end

  def create
    @new_session = TodoApi::Session.new
    @new_session.get_user(user_login_params)
    if @new_session.user_id
      flash[:success] = "Welcome back!"
      log_in(user_login_params[:password], @new_session.user_id, @new_session.auth_token)
      redirect_back_or_to(user_url(@new_session.user_id))
    else
      flash.now[:danger] = "Could not login"
      render 'sessions/new'
    end
  end

  def destroy
    flash[:success] = "Seeya later alligator!"
    log_out
    redirect_to root_url
  end

  private

    def user_login_params
      params.permit(:email, :password)
    end
end
