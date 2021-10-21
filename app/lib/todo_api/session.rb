class TodoApi::Session < TodoApi::Application

  attr_reader :user_id, :auth_token

  def get_user(user_login_params)
    login_user_url = BASE_REQUEST_URL + "/auth/login"
    response = HTTParty.post(
      login_user_url, 
      headers: {
        "Content-Type" => "application/json",
      },
      body: {
        email: user_login_params[:email],
        password: user_login_params[:password]
      }.to_json
    )
    response_object = JSON.parse(response.body, symbolize_names: true)
    @user_id = response_object[:user_id]
    @auth_token = response_object[:auth_token]
  end

end