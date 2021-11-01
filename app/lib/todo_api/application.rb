class TodoApi::Application < ActionController::Base

  include SessionsHelper

  BASE_REQUEST_URL = 'http://127.0.0.1:3000'

end