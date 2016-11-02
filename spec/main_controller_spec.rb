require 'spec_helper'
require 'json'
require './main_controller.rb'

RSpec.describe MainController do
  def app
    MainController
  end

  describe 'GET /info' do
    it 'returns HELLO API-WORLD' do
      get '/info'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'HELLO API-WORLD'
    end
  end
end
