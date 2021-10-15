class TodosController < ApplicationController

  def new
  end

  def create
    response = create_todo(todo_params)
    response_object = JSON.parse(response.body, symbolize_names: true)
    if status == 200
      # flash message
      redirect_to todo_url(response_object[:id])
    else
      # flash message
      render 'todos/new'
    end
  end

  def show
    response = show_todo(params[:id])
    @todos_object = JSON.parse(response.body, symbolize_names: true)
    @title = @todos_object[:title]
    @items_count = @todos_object[:items].count
  end

  def edit
  end

  def update
    response = update_todo(todo_params, params[:id])
    if status == 200
      # flash message
      redirect_to todo_url(params[:id])
    else
      # flash message
      render 'edit'
    end
  end

  def index
    response = index_todos
    @all_todos_object = JSON.parse(response.body, symbolize_names: true)
    @count = @all_todos_object.count
  end

  def destroy
    delete_todo(params[:id])
    redirect_to todos_url
  end

  private
    def todo_params
      params.permit(:title)
    end
end
