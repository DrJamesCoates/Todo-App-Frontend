require 'rails_helper'

RSpec.describe TodoApi::Item, type: :request do

  let(:create_todo_attributes) do
    { title: "Create Todo", deadline: Date.today }
  end
  let(:valid_update_attributes) do
    { name: "Update Item", done: true }
  end
  let(:invalid_update_attributes) do
    { name: "", done: nil }
  end
  let(:todo_id) { 554 }
  let(:auth_token) { "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0OTcsImV4cCI6MTYzNTU3NDY0NH0.Xg_9sljeCATwK7KH75XmpVfVKTLldBZX9jodMu7q7uE" }
  let(:valid_name) { "First Item" }
  let(:id) { 239 }
  let(:invalid_name) { "" }
  
  describe 'Item.create' do
    it 'sets the id and done attributes', :vcr do
      todo = TodoApi::Todo.new(nil, auth_token)
      todo.create(create_todo_attributes)
      item = TodoApi::Item.new(nil, valid_name, todo.id, auth_token)
      item.create
      expect(item.id).not_to be_nil
      expect(item.done).to eq(false)
    end

    it 'returns error code 422 with invalid parameters', :vcr do
      item = TodoApi::Item.new(nil, invalid_name, todo_id, auth_token)
      item.create
      expect(item.id).to be_nil
      expect(item.response.code).to eq(422)
    end
  end

  describe 'Item.show' do
    it 'returns the name and the done status', :vcr do
      item = TodoApi::Item.new(id, nil, todo_id, auth_token)
      item.show
      expect(item.name).to eq(valid_name)
      expect(item.done).to eq(false)
    end
  end

  describe 'Item.update' do
    it 'returns the name and the done status', :vcr do
      item = TodoApi::Item.new(id, nil, todo_id, auth_token)
      item.update(valid_update_attributes)
      expect(item.name).to eq(valid_update_attributes[:name])
      expect(item.done).to eq(valid_update_attributes[:done])
    end

    it 'returns status code 422 with invalid update parameters', :vcr do
      item = TodoApi::Item.new(id, nil, todo_id, auth_token)
      item.update(invalid_update_attributes)
      expect(item.response.code).to eq(422)
    end
  end

  describe 'Item.destroy' do
    it 'returns status code 204', :vcr do
      item = TodoApi::Item.new(id, nil, todo_id, auth_token)
      item.destroy
      expect(item.response.code).to eq(204)
    end
  end
end