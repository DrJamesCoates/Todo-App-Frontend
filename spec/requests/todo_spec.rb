require 'rails_helper'


RSpec.describe TodoApi::Todo, type: :request do
  
  let(:auth_token) { "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0OTcsImV4cCI6MTYzNTU3NDY0NH0.Xg_9sljeCATwK7KH75XmpVfVKTLldBZX9jodMu7q7uE" }
  let(:valid_create_attributes) do
    { title: "Create Todo", deadline: Date.today }
  end
  let(:invalid_create_attributes) do
    { title: "", deadline: nil }
  end
  let(:update_attributes) do
    { title: "Update Todo", deadline: Date.tomorrow }
  end
  let(:invalid_update_attributes) do
    { title: "", deadline: nil }
  end

  describe 'Todo.create' do
    it 'sets the todo id', :vcr do
      todo = TodoApi::Todo.new(nil, auth_token)
      todo.create(valid_create_attributes)
      expect(todo.id).not_to be_nil
    end

    it 'returns status code 422 with invalid parameters', :vcr do
      todo = TodoApi::Todo.new(nil, auth_token)
      todo.create(invalid_create_attributes)
      expect(todo.response.code).to eq(422)
    end
  end

  let(:id) { 555 }

  describe 'Todo.show' do
    it 'sets the title, deadline and items attributes', :vcr do
      todo = TodoApi::Todo.new(id, auth_token)
      todo.show
      expect(todo.title).to eq(valid_create_attributes[:title])
      expect(todo.deadline).to eq(valid_create_attributes[:deadline].to_s)
      expect(todo.items).not_to be_nil
    end
  end

  describe 'Todo.index' do
    it 'sets the all_todos attribute', :vcr do
      todos = TodoApi::Todo.new(nil, auth_token)
      todos.index
      expect(todos.all_todos).not_to be_nil
    end
  end

  describe 'Todo.update' do
    it 'sets the updated title', :vcr do
      todo = TodoApi::Todo.new(id, auth_token)
      todo.update(update_attributes)
      expect(todo.title).to eq(update_attributes[:title])
    end

    it 'returns status code 422 with invalid update parameters', :vcr do
      todo = TodoApi::Todo.new(id, auth_token)
      todo.update(invalid_update_attributes)
      expect(todo.response.code).to eq(422)
    end
  end

  describe 'Todo.destroy' do
    it 'returns status code 204', :vcr do
      todo = TodoApi::Todo.new(id, auth_token)
      todo.destroy
      expect(todo.response.code).to eq(204)
    end
  end
end


