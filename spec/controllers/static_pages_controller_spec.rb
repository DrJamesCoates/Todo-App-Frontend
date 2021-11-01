require 'rails_helper'

RSpec.describe StaticPagesController, type: :request do
  describe 'GET /home' do
    it 'renders the home view' do
      get '/'
      expect(response).to render_template(:home)
    end
  end

  describe 'GET /contact' do
    it 'renders the contact view' do
      get '/contact'
      expect(response).to render_template(:contact)
    end
  end
end
