class TodoApi::Item < TodoApi::Application

  attr_reader :id, :name, :done, :todo_id, :auth_token, :response

  def initialize(id = nil, name = nil, todo_id = nil, auth_token = nil, done = false)
    @id = id
    @name = name
    @todo_id = todo_id
    @auth_token = auth_token
    @done = done
  end

  def create
    create_item_url = BASE_REQUEST_URL + "/todos/#{@todo_id}/items"
    @response = HTTParty.post(
      create_item_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      },
      body: {
        name: @name,
        done: false,
        todo_id: @todo_id
      }.to_json
    )
    @response_object = JSON.parse(@response.body, symbolize_names: true)
    @id = @response_object[:items][0][:id]
    @done = @response_object[:items][0][:done]
  end

  def update(item_params)
    edit_item_url = BASE_REQUEST_URL + "/todos/#{@todo_id}/items/#{@id}"
    @response = HTTParty.put(
      edit_item_url, 
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      }, 
      body: {
        name: item_params[:name],
        done: item_params[:done]
      }.to_json
    )
    @response_object = JSON.parse(@response.body, symbolize_names: true)
    @name = @response_object[:name]
    @done = @response_object[:done]
  end

  def destroy
    destroy_item_url = BASE_REQUEST_URL + "/todos/#{@todo_id}/items/#{@id}"
    @response = HTTParty.delete(
      destroy_item_url, 
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      }
    )
  end

end