require 'rails_helper'

RSpec.describe TodoApi::Session, type: :request do

  let(:not_signed_up_attributes) do
    { email: "notsignedup@email.com", password: "password" }
  end
  let(:create_attributes) do
    { name: "Signed up", email: "signedup@email.com", password: "password", password_confirmation: "password" }
  end
  let(:signed_up_attributes) do
    { email: "signedup@email.com", password: "password" }
  end

  describe 'Session.get_user' do
    it 'returns status code 401 when the user does not exist', :vcr do
      session = TodoApi::Session.new
      session.get_user(not_signed_up_attributes)
      expect(session.response.code).to eq(401)
    end

    it 'returns user_id and auth_token', :vcr do
      user = TodoApi::User.new
      user.create(create_attributes)
      session = TodoApi::Session.new
      session.get_user(signed_up_attributes)
      expect(session.user_id).to eq(user.id)
      expect(session.auth_token).not_to be_nil
    end
  end
end