require 'rails_helper'

RSpec.describe SessionsController, type: :request do

  let(:valid_attributes) do
    { email: "noel@miller.com", password: "password" }
  end
  let(:invalid_attributes) do
    { email: "invalid@email", password: "randompassword" }
  end

  describe 'GET /login' do
    it 'renders the new view', :vcr do
      get '/login'
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /login' do
    context 'with invalid parameters' do

      it 'renders an error message and renders the new view', :vcr do
        post '/login', params: invalid_attributes
        expect(flash["danger"]).not_to be_nil
        expect(response).to render_template(:new)
      end
    end

    context 'with valid parameters' do

      it 'renders success message, redirects to user show view and stores user_id and auth_token in session', :vcr do
        post '/login', params: valid_attributes
        expect(flash["success"]).to eq("Welcome back!")
        expect(response).to redirect_to(user_url(session[:user_id]))
        expect(session[:user_id]).not_to be_nil
        expect(session[:auth_token]).not_to be_nil
      end
    end
  end

  describe 'POST /logout' do

    before(:each) { post '/login', params: valid_attributes }
    context 'when logged in' do

      it 'deletes user_id and auth_token from session, redirects to root url and renders a success message', :vcr do
        delete '/logout'
        expect(session[:user_id]).to be_nil
        expect(session[:auth_token]).to be_nil
        expect(response).to redirect_to(root_url)
        expect(flash["success"]).not_to be_nil
      end
    end

    context 'when not logged in', :vcr do

      it 'redirects to login view and renders an error message' do
        delete '/logout'

        delete '/logout'
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).to eq("Please login")
      end
    end
  end
end
