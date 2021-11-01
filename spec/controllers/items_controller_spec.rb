require 'rails_helper'

RSpec.describe ItemsController, type: :request do

  let(:login) do
    post '/login', params: { email: "noel@miller.com", password: "password" }
  end
  let(:valid_attributes) do
    { name: "First item", done: false }
  end
  let(:invalid_attributes) do
    { name: "", done: nil }
  end
  let(:valid_update_params) do
    { name: "First update", done: true }
  end
  let(:todo_id) { 518 }
  let(:item_id) { 240 }
  
  describe 'GET /todos/:id/items/new' do
    context 'when not logged in' do
      
      it 'redirects to login page and renders an error message', :vcr do
        get "/todos/#{todo_id}/items/new"
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).to eql("Please login")
      end
    end

    context 'when logged in' do
      
      it 'renders new page', :vcr do
        login
        get "/todos/#{todo_id}/items/new"
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST /todos/:id/items/' do
    context 'when not logged in' do

      it 'redirects to login page and renders error message', :vcr do
        post "/todos/#{todo_id}/items", params: valid_attributes
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).to eql("Please login")
      end
    end

    context 'when logged in and valid parameters' do
      
      it 'redirects to todo show page and renders success message', :vcr do
        login
        post "/todos/#{todo_id}/items", params: valid_attributes
        expect(response).to redirect_to(todo_url(todo_id))
        expect(flash["success"]).not_to be_nil
      end
    end

    context 'when logged in and invalid parameters' do
      
      it 'renders an error message and renders the item new view', :vcr do
        login
        post "/todos/#{todo_id}/items", params: invalid_attributes
        expect(flash["danger"]).not_to be_nil
        expect(response).to redirect_to(new_todo_item_url)
      end
    end
  end

  describe 'GET /todos/:todo_id/items/:id/edit' do
    context 'when not logged in' do

      it 'redirects to login page and renders error message', :vcr do
        get "/todos/#{todo_id}/items/#{item_id}/edit"
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).to eql("Please login")
      end
    end

    context 'when logged in' do
      
      it 'renders the edit view', :vcr do
        login
        get "/todos/#{todo_id}/items/#{item_id}/edit"
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT /todos/:todo_id/items/:id' do
    context 'when not logged in' do

      it 'redirects to login page and renders error message', :vcr do
        put "/todos/#{todo_id}/items/#{item_id}", params: valid_update_params
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).to eql("Please login")
      end
    end

    context 'when logged in and valid update parameters' do
      
      it 'redirects to todo show view and renders success message', :vcr do
        login
        patch "/todos/#{todo_id}/items/#{item_id}", params: valid_update_params
        expect(response).to redirect_to(todo_url(todo_id))
        expect(flash["success"]).to eql("Todo item updated!")
      end
    end

    context 'when logged in and invalid update parameters' do
      
      it 'rerenders edit page and renders an error message', :vcr do
        login
        patch "/todos/#{todo_id}/items/#{item_id}", params: invalid_attributes
        expect(response).to redirect_to(edit_todo_item_url(todo_id: todo_id, id: item_id))
        expect(flash["danger"]).not_to be_nil
      end
    end
  end

  describe 'DELETE /todos/:todo_id/items/:id' do
    context 'when not logged in' do

      it 'redirects to login page', :vcr do
        delete "/todos/#{todo_id}/items/242"
        expect(response).to redirect_to(login_url)
        expect(flash["danger"]).to eql("Please login")
      end
    end

    context 'when logged in' do

      it 'renders success message and redirects to todo show view', :vcr do
        login
        delete "/todos/#{todo_id}/items/242"
        expect(flash["success"]).not_to be_nil
        expect(response).to redirect_to(todo_url(todo_id))
      end
    end
  end

end
