class UsersController < ApplicationController

  before_action :logged_in?, only: [:show, :edit, :update, :destroy]

  def new
  end

  def create
    User.create(user_params)
    if User.id
      store_token(User.auth_token)
      log_in(User.id)
      # flash message
      redirect_to user_url(User.id)
    else
      # flash message
      render 'static_pages/home'
    end
  end

  def show
    User.show
    @name = User.name
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
end
