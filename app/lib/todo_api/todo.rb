class TodoApi::Todo < TodoApi::Application

  attr_reader :id, :title, :items, :all_todos, :response, :deadline

  def initialize(id = nil, auth_token = nil)
    @id = id
    @auth_token = auth_token
  end

  def create(todo_params)
    create_todo_url = BASE_REQUEST_URL + '/todos'
    @response = HTTParty.post(
      create_todo_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      }, 
      body: {
        title: todo_params[:title], 
        deadline: todo_params[:deadline]
      }.to_json
    )
    @response_object = JSON.parse(@response.body, symbolize_names: true)
    @id = @response_object[:id]
  end

  def show
    show_todo_url = BASE_REQUEST_URL + "/todos/#{@id}"
    @response = HTTParty.get(
      show_todo_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      }
    )
    @response_object = JSON.parse(@response.body, symbolize_names: true)
    @title = @response_object[:title]
    @deadline = @response_object[:deadline]
    @items = @response_object[:items]
  end

  def index
    index_todos_url = BASE_REQUEST_URL + '/todos'
    @response = HTTParty.get(
      index_todos_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      }
    )
    @all_todos = JSON.parse(@response.body, symbolize_names: true)
  end

  def update(todo_params)
    update_todo_url = BASE_REQUEST_URL + "/todos/#{@id}"
    @response = HTTParty.put(
      update_todo_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      },
      body: {
        title: todo_params[:title],
        deadline: todo_params[:deadline]
      }.to_json
    )
    @response_object = JSON.parse(@response.body, symbolize_names: true)
    @title = @response_object[:title]
  end

  def destroy
    delete_todo_url = BASE_REQUEST_URL + "/todos/#{@id}"
    @response = HTTParty.delete(
      delete_todo_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      }
    )
  end
end