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

  describe 'PUT /api/Calendars' do
    context 'with legal data' do
      it 'returns some info on saved object' do
        body = { name: 'event', date: '2016-10-30' }.to_json
        put '/api/Calendars', params = body
        expect(last_response.status).to eq 200
      end
    end

    context 'with illegal data format' do
      it 'rejects with 422' do
        body = { name: 'event', date: '2016-10-30' } # NOT .to_json
        put '/api/Calendars', params = body
        expect(last_response.status).to eq 422
      end
    end

    context 'without name in json body' do
      it 'rejects json body with 422' do
        body = { nope: 'event', date: '2016-10-30' }.to_json
        put '/api/Calendars', params = body
        expect(last_response.status).to eq 422
      end
    end

    context 'without name in json body' do
      it 'rejects json body with 422' do
        body = { name: 'event', dati: '2016-10-30' }.to_json
        put '/api/Calendars', params = body
        expect(last_response.status).to eq 422
      end
    end
  end
end
