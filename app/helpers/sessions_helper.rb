module SessionsHelper

  def get_user(user_login_params)
    login_user_url = "http://127.0.0.1:3000" + "/auth/login"
    HTTParty.post(
      login_user_url, 
      headers: {
        "Content-Type" => "application/json",
      },
      body: {
        email: user_login_params[:email],
        password: user_login_params[:password]
      }.to_json
    )
  end

  def log_in(user_id)
    session[:user_id] = user_id
  end

  def log_out
    session.delete(:user_id)
  end

  def logged_in?
    session[:user_id] != nil
  end

  def current_user
    session[:user_id]
  end
end
