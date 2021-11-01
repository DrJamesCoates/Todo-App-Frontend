require 'rails_helper'

RSpec.describe TodosController, type: :request do

  let(:login) do
    post '/login', params: { email: "noel@miller.com", password: "password" }
  end
  let(:valid_attributes) do
    { title: "New Todo", deadline: Date.today }
  end
  let(:invalid_attributes) do
    { title: "", deadline: nil }
  end
  let(:valid_update_attributes) do
    { title: "New update", deadline: Date.tomorrow }
  end
  let(:todo_id) { 518 }

  describe 'GET /todos/new' do
    context 'when not logged in' do

      it 'redirects to login page and flashes error message', :vcr do
        get '/todos/new'
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when logged in' do
      
      it 'renders the new page', :vcr do
        login
        get '/todos/new'
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST /todos' do
    context 'when not logged in' do

      it 'redirects to login page and renders an error message', :vcr do
        post '/todos', params: valid_attributes
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when logged in and valid parameters' do

      it 'renders a success message', :vcr do
        login
        response = post '/todos', params: valid_attributes
        expect(flash["success"]).not_to be_nil
      end
    end

    context 'when logged in and invalid parameters' do
      
      it 'renders an error message and renders the new page', :vcr do
        login
        post '/todos', params: invalid_attributes
        expect(flash).not_to be_nil
        expect(response).to redirect_to(new_todo_url)
      end
    end
  end

  describe 'GET /todos' do
    context 'when not logged in' do

      it 'redirects to login page and renders an error message', :vcr do
        get '/todos'
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when logged in' do
      
      it 'renders the index page', :vcr do
        login
        get '/todos'
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET /todos/:id' do
    context 'when not logged in' do

      it 'redirects to login page and renders an error message', :vcr do
        get "/todos/#{todo_id}"
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when logged in' do
      
      it 'renders todos show page', :vcr do
        login
        get "/todos/#{todo_id}"
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET todo/:id/edit' do
    context 'when not logged in' do

      it 'redirects to login page and renders an error message', :vcr do
        get "/todos/#{todo_id}/edit"
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when logged in' do
      
      it 'renders the edit view', :vcr do
        login
        get "/todos/#{todo_id}/edit"
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT todos/:id' do
    context 'when not logged in' do

      it 'redirects to login page', :vcr do
        put "/todos/#{todo_id}", params: valid_attributes
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when logged in and valid parameters' do

      it 'redirects to show page and flashes success message', :vcr do
        login
        put "/todos/#{todo_id}", params: valid_update_attributes
        expect(response).to redirect_to(todo_url(todo_id))
        expect(flash["success"]).to eq("Todo updated!")
      end
    end

    context 'when logged in and invalid parameters' do

      it 'renders edit page and an error message', :vcr do
        login
        put "/todos/#{todo_id}", params: invalid_attributes
        expect(response).to redirect_to(edit_todo_url(todo_id))
        expect(flash["danger"]).not_to be_nil
      end
    end
  end

  describe 'DELETE todos/:id' do
    context 'when not logged in' do

      it 'redirects to login page', :vcr do
        delete '/todos/559'
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).not_to be_nil
      end
    end

    context 'when logged in' do

      it 'redirects to index page', :vcr do
        login
        delete "/todos/559"
        expect(flash["success"]).to eq("Todo deleted!")
        expect(response).to redirect_to(todos_url)
      end
    end
  end
end
