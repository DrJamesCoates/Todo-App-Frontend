require 'rails_helper'

RSpec.describe TodoApi::User, type: :request do
  let(:signup_attributes) do
    { name: "Signup Name", email: "signup@email.com", password: "password", password_confirmation: "password" }
  end
  let(:invalid_attributes) do
    { name: "", email: "", password: "foo", password_confirmation: "bar" }
  end
  let(:update_attributes) do
    { name: "Update Name", email: "update@email.com", password: "password12", password_confirmation: "password12" }
  end

  describe 'User.create' do
    it 'sets user_id and auth_token attributes', :vcr do
      user = TodoApi::User.new
      user.create(signup_attributes)
      expect(user.id).not_to be_nil
      expect(user.auth_token).not_to be_nil
    end

    it 'returns status code 422 with invalid signup attributes', :vcr do
      user = TodoApi::User.new
      user.create(invalid_attributes)
      expect(user.response.code).to eq(422)
    end
  end


  let(:id) { 513 }
  let(:auth_token) { "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0OTcsImV4cCI6MTYzNTU3NDY0NH0.Xg_9sljeCATwK7KH75XmpVfVKTLldBZX9jodMu7q7uE" }

  describe 'User.show' do
    it 'sets name and email attributes', :vcr do
      user = TodoApi::User.new(id, auth_token)
      user.show
      expect(user.name).to eq(signup_attributes[:name])
      expect(user.email).to eq(signup_attributes[:email])
    end
  end

  describe 'User.update' do
    it 'sets the name attribute', :vcr do
      user = TodoApi::User.new(id, auth_token)
      user.update(update_attributes)
      expect(user.name).to eq(update_attributes[:name])
    end

    it 'returns status code 422 with invalid update attributes', :vcr do
      user = TodoApi::User.new(id, auth_token)
      user.update(invalid_attributes)
      expect(user.response.code).to eq(422)
    end
  end

  describe 'User.destroy' do
    it 'returns status code 204', :vcr do
      user = TodoApi::User.new(id, auth_token)
      user.destroy
      expect(user.response.code).to eq(204)
    end
  end
  
end

