require 'spec_helper'
require 'json'
require './main_controller.rb'
require './config/sequel_connect'

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
        count = DB[:events].count
        body = { name: 'event', date: '2016-10-30' }.to_json
        put '/api/Calendars', params = body
        expect(last_response.status).to eq 200
        response = JSON.parse(last_response.body)
        expect(response.has_key?('id')).to eq true
        expect(response['name']).to eq JSON.parse(body)['name']
        expect(response['date']).to eq JSON.parse(body)['date']
        expect(DB[:events].count).to eq count + 1
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

  describe 'GET /api/Calendars/timeToDate' do
    context 'with existing event' do
      before do
        DB[:events].insert(name: 'testEvent', date: Date.today + 1)
      end

      it 'returns time to date' do
        get '/api/Calendars/timeToDate?eventName=testEvent'
        expect(last_response.status).to eq 200
        # TODO: check that time to date is calculated
      end
    end

    context 'with non-existing event' do
      it 'returns 404' do
        get '/api/Calendars/timeTodate?eventName=immaginative'
        expect(last_response.status).to eq 404
      end
    end
  end
end
