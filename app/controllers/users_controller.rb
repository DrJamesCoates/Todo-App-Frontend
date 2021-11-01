class UsersController < ApplicationController

  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]

  def new
  end

  def create
    @user = TodoApi::User.new
    @user.create(user_params)
    if response_status_ok?(@user.response)
      flash[:success] = "Welcome to the Todo App!"
      log_in(user_params[:password], @user.id, @user.auth_token)
      redirect_to user_url(current_user)
    else
      api_error_response(@user, signup_url, @user)
    end
  end

  def show
    @user = TodoApi::User.new(current_user, session[:auth_token])
    @user.show
    if response_status_ok?(@user.response)
      @todo = TodoApi::Todo.new(nil, session[:auth_token])
      @todo.index
      @all_todos = @todo.all_todos.sort_by{ |todo| todo[:deadline] }
      @todos_count = @all_todos.count
    else
      api_error_response(@user, root_url, nil)
    end
  end

  def edit
    @user = TodoApi::User.new(current_user, session[:auth_token])
    @user.show
    api_error_response(@user, user_url(@user.id), @user) unless response_status_ok?(@user.response)
  end

  def update
    @user = TodoApi::User.new(current_user, session[:auth_token])
    @user.update(user_params)
    if response_status_ok?(@user.response)
      flash[:success] = "Profile updated!"
      redirect_to user_url(@user.id)
    else
      @old_user = TodoApi::User.new(current_user, session[:auth_token])
      @old_user.show
      api_error_response(@user, edit_user_url(@user.id), @old_user)
    end
  end

  def destroy
    @user = TodoApi::User.new(current_user, session[:auth_token])
    @user.destroy
    if response_status_ok?(@user.response)
      log_out
      redirect_to root_url
    else
      api_error_response(@user, root_url, nil)
    end
  end

  private
    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
    
end
