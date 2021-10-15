module UsersHelper

  def create_user(user_params)
    create_user_url = 'http://127.0.0.1:3000' + '/signup'
    HTTParty.post(
      create_user_url, 
      headers: {
        "Content-Type" => "application/json"
      }, 
      body: {
        name: user_params[:name],
        email: user_params[:email],
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation]
      }.to_json
    )
  end

  def show_user(user_id)
    show_user_url = "http://127.0.0.1:3000" + "/users/#{user_id}"
    HTTParty.get(
      show_user_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "#{session[:auth_token]}"
      }
    )
  end

  def get_user_todos(user_id)
    get_user_url = 'http://127.0.0.1:3000' + "/users/#{user_id}/todos"
    HTTParty.get(
      get_user_url, 
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => session[:auth_token]
      }
    )
  end
end
