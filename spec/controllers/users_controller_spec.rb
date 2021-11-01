require 'rails_helper'

RSpec.describe UsersController, type: :request do

  let(:valid_attributes) do
    { name: "Noel Miller", email: "noel@miller.com", password: "password", password_confirmation: "password" }
  end
  let(:invalid_attributes) do
    { name: "", email: "", password: "foo", password_confirmation: "bar" }
  end
  let(:valid_update_attributes) do
    { name: "James", email: "james@example.com", password: "password123", password_confirmation: "password123" }
  end
  let(:login) do
    post '/login', params: { email: "noel@miller.com", password: "password" }
  end

  describe 'GET /signup' do

    it 'renders the users new view', :vcr do
      get("/signup")
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create'  do
    context 'with valid params' do

      it 'receives an auth token and a user id and stores it in sessions', :vcr do
        post '/users', params: valid_attributes
        expect(session[:auth_token]).not_to be_nil
        expect(session[:user_id]).not_to be_nil
      end
    end

    context 'with invalid params' do

      it 'renders an error message and redirects to signup page', :vcr do
        post '/users', params: invalid_attributes
        expect(flash["danger"]).not_to be_nil
        expect(response).to redirect_to(signup_url)
      end
    end
  end

  let(:auth_token) { "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo1MTcsImV4cCI6MTYzNTU5MzUzOH0.yaP-S3_yRTbrKI_fvAXpQ4laMK4xN3rruarAdmu3Xr4" }
  let(:user_id) { 517 }

  describe 'GET /users/:id' do
    context 'when user not logged in' do

      it 'redirects to login page and flashes an error message', :vcr do
        get "/users/#{user_id}"
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when the user is logged in' do

      before(:each) { login }

      it 'renders user show page and returns a 200 status code', :vcr do
        get "/users/#{user_id}"
        expect(response).to render_template(:show)
        expect(response.code).to eq("200")
      end
    end
  end

  describe 'GET /users/:id/edit' do
    context 'when user not logged in' do
      
      it 'redirects to login page and renders an error message', :vcr do
        get "/users/#{user_id}/edit"
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when user is logged in' do

      before(:each) { login }
      
      it 'renders edit page and returns a status code 200', :vcr do
        get "/users/#{user_id}/edit"
        expect(response).to render_template(:edit)
        expect(response.code).to eq("200")
      end
    end
  end

  describe 'PUT /users/:id' do
    context 'when user not logged in' do
      
      it 'redirects to login page and renders error message', :vcr do
        put "/users/#{user_id}", params: valid_attributes
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when user logged in' do

      before(:each) { login }
      
      it 'redirects to edit view and renders error message with invalid update params', :vcr do
        put "/users/#{user_id}", params: invalid_attributes
        expect(response).to redirect_to(edit_user_url(user_id))
        expect(flash["danger"]).not_to be_nil
      end

      it 'redirects to user show page and renders success message with valid update params', :vcr do
        put "/users/#{user_id}", params: valid_update_attributes
        expect(response).to redirect_to(user_url(user_id))
        expect(flash["success"]).not_to be_nil
      end
    end
  end

  describe 'DELETE /users/:id' do
    context 'when user not logged in' do
      
      it 'redirects to login page and renders an error message', :vcr do
        delete "/users/#{user_id}"
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when user is logged in' do
      
      it 'redirects to root_url and deletes session user id, auth token and password', :vcr do
        post '/users', params: { name: "New name", email: "delete@email.com", password: "password", password_confirmation: "password" }
        delete "/users/#{session[:user_id]}"

        expect(response).to redirect_to(root_url)
        expect(session[:user_id]).to be_nil
        expect(session[:auth_token]).to be_nil
        expect(session[:password]).to be_nil
      end
    end
  end

end
