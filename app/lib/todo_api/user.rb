class TodoApi::User < TodoApi::Application

  attr_reader :id, :auth_token, :name, :response, :email

  def initialize(id = nil, auth_token = nil, name = nil, email = nil)
    @id = id
    @auth_token = auth_token
    @name = name
    @email = email
  end
  
  def create(user_params)
    create_user_url = BASE_REQUEST_URL + '/signup'
    @response = HTTParty.post(
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
    @response_object = JSON.parse(@response.body, symbolize_names: true)
    @id = @response_object[:user_id]
    @auth_token = @response_object[:auth_token]
  end

  def show
    show_user_url = BASE_REQUEST_URL + "/users/#{@id}"
    @response = HTTParty.get(
      show_user_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      }
    )
    @response_object = JSON.parse(@response.body, symbolize_names: true)
    @name = @response_object[:user_name]
    @email = @response_object[:user_email]
  end

  def update(user_params)
    update_user_url = BASE_REQUEST_URL + "/user/#{@id}"
    @response = HTTParty.put(
      update_user_url,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      },
      body: {
        name: user_params[:name],
        email: user_params[:email],
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation]
      }.to_json
    )
    @response_object = JSON.parse(@response.body, symbolize_names: true)
    @name = @response_object[:name]
  end

  def destroy
    delete_user_url = BASE_REQUEST_URL + "/users/#{@id}"
    @response = HTTParty.delete(
      delete_user_url, 
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => @auth_token
      }
    )
  end

end

