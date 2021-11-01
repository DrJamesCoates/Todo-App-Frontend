class TodosController < ApplicationController

  before_action :logged_in_user

  def new
  end

  def create
    @todo = TodoApi::Todo.new(nil, session[:auth_token])
    @todo.create(todo_params)
    if response_status_ok?(@todo.response)
      redirect_to todo_url(@todo.id)
    else 
      api_error_response(@todo, new_todo_url, @todo)
    end
  end

  def show
    @todo = TodoApi::Todo.new(params[:id], session[:auth_token])
    @todo.show
    if response_status_ok?(@todo.response)
      @all_items = @todo.items.sort_by{ |item| item[:done] == true ? 1 : 0 }
      @items_count = @all_items.count
      @completed_items_count = @all_items.count{ |item| item[:done] == true }
    else
      api_error_response(@todo, user_url(current_user), @todo)
    end
  end

  def index
    @todos = TodoApi::Todo.new(nil, session[:auth_token])
    @todos.index
    if response_status_ok?(@todos.response)
      @all_todos = @todos.all_todos.sort_by{ |todo| todo[:deadline] }
      @count = @all_todos.count
    else
      api_error_response(@todos, user_url(current_user), @todos)
    end
  end

  def edit
    @todo = TodoApi::Todo.new(params[:id], session[:auth_token])
    @todo.show
    api_error_response(@todo, user_url(current_user), @todo) unless response_status_ok?(@todo.response)
  end

  def update
    @todo = TodoApi::Todo.new(params[:id], session[:auth_token])
    @todo.update(todo_params)
    if response_status_ok?(@todo.response)
      flash[:success] = "Todo updated!"
      redirect_to todo_url(params[:id])
    else
      @old_todo = TodoApi::Todo.new(params[:id], session[:auth_token])
      @old_todo.show
      api_error_response(@todo, edit_todo_url(params[:id]), @old_todo)
    end
  end

  def destroy
    @todo = TodoApi::Todo.new(params[:id], session[:auth_token])
    @todo.destroy
    if response_status_ok?(@todo.response)
      flash[:success] = "Todo deleted!"
      redirect_to todos_url
    else
      api_error_response(@todo, user_url(current_user))
    end
  end

  private
    def todo_params
      params.permit(:title, :deadline)
    end
end
