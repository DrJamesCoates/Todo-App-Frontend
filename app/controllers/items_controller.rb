class ItemsController < ApplicationController

  before_action :logged_in_user

  def new
    @todo_id = params[:todo_id]
    @todo_title = params[:todo_title]
  end

  def create
    @item = TodoApi::Item.new(nil, item_params[:name], item_params[:todo_id], session[:auth_token])
    @item.create
    if response_status_ok?(@item.response)
      @name = @item.name
      @done = @item.done
      redirect_to todo_url(@item.todo_id)
    else
      api_error_response(@item, new_todo_item_url, nil)
    end
  end

  def edit
    @item = TodoApi::Item.new(params[:id], nil, params[:todo_id], session[:auth_token])
    @item.show
    api_error_response(@item, todos_url(@item.todo_id), nil) unless response_status_ok?(@item.response)
  end

  def update
    @item = TodoApi::Item.new(params[:id], nil, item_params[:todo_id], session[:auth_token])
    @item.update(item_params)
    if response_status_ok?(@item.response)
      flash[:success] = "Todo item updated!"
      redirect_to todo_url(item_params[:todo_id])
    else
      @old_item = TodoApi::Item.new(params[:id])
      @old_item.show
      api_error_response(@item, edit_todo_item_url, @old_item)
    end
  end

  def destroy
    @item = TodoApi::Item.new(params[:id], nil, item_params[:todo_id], session[:auth_token])
    @item.destroy
    if response_status_ok?(@item.response)
      flash[:success] = "Item deleted!"
      redirect_to todo_url(item_params[:todo_id])
    else
      api_error_response(@item, todo_url(item_params[:todo_id]), nil)
    end
  end

  private

    def item_params
      params.permit(:name, :done, :todo_id)
    end
  
end
