module SessionsHelper

  def log_in(password, user_id, auth_token)
    session[:password] = password
    session[:user_id] = user_id
    session[:auth_token] = auth_token
  end

  def log_out
    session.delete(:password)
    session.delete(:user_id)
    session.delete(:auth_token)
  end

  def logged_in?
    session[:user_id] != nil
  end

  def current_user
    session[:user_id]
  end

  # redirects to the stored url or the default
  def redirect_back_or_to(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # stores url trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
