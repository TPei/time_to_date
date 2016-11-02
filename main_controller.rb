require 'sinatra'
require 'json'
require 'date'
require './config/sequel_connect'

class MainController < Sinatra::Base
  get '/info' do
    'HELLO API-WORLD'
  end

  # expects json body
  # of format { name: String, date: String }
  put '/api/Calendars' do
    begin
      data = JSON.parse(request.body.read)
      name = data.fetch('name')
      date = parse_date data.fetch('date')

      # TODO: what if event name already exists?
      id = DB[:events].insert(name: name, date: date)

      { id: id, name: name, date: date }.to_json
    rescue JSON::ParserError, ArgumentError, TypeError, KeyError
      halt 422
    end
  end

  # expects ?eventName=something as GET query parameters
  get '/api/Calendars/timeToDate' do
    event_name = params[:eventName]
    events = DB[:events].where(name: event_name).to_a

    if events.empty?
      halt 404
    else
      # TODO: calculate time to date
      events[0].to_json
    end
  end

  def parse_date(string_date)
    Date.parse(string_date)
  end
end

use MainController
