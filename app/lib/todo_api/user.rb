class User 
  class << self

    attr_reader :id, :auth_token, :name
    
    def create(user_params)
      unless @id
        create_user_url = 'http://127.0.0.1:3000' + '/signup'
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
    end

    def show
      unless @name
        show_user_url = "http://127.0.0.1:3000" + "/users/#{@id}"
        @response = HTTParty.get(
          show_user_url,
          headers: {
            "Content-Type" => "application/json",
            "Authorization" => @auth_token
          }
        )
        @response_object = JSON.parse(@response.body, symbolize_names: true)
        @name = @response_object[:user_name]
      end
    end

  end
end

