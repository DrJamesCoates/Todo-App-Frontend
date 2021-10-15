module TodosHelper

  def create_todo(todo_params)
    create_todo_url = 'http://127.0.0.1:3000/todos'
    HTTParty.post(
      create_todo_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => session[:auth_token]
      }, 
      body: {
        title: todo_params[:title]
      }.to_json
    )
  end

  def show_todo(todo_params)
    show_todo_url = "http://127.0.0.1:3000/todos/#{todo_params}"
    HTTParty.get(
      show_todo_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => session[:auth_token]
      }
    )
  end

  def index_todos
    index_todos_url = 'http://127.0.0.1:3000/todos'
    HTTParty.get(
      index_todos_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => session[:auth_token]
      }
    )
  end

  def update_todo(todo_params, id)
    update_todo_url = "http://127.0.0.1:3000/todos/#{id}"
    HTTParty.put(
      update_todo_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => session[:auth_token]
      },
      body: {
        title: todo_params[:title]
      }.to_json
    )
  end

  def delete_todo(id)
    delete_todo_url = "http://127.0.0.1:3000/todos/#{id}"
    HTTParty.delete(
      delete_todo_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => session[:auth_token]
      }
    )
  end

end
