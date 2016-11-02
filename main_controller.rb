require 'sinatra'
require 'json'
require 'date'
require './config/sequel_connect'

class MainController < Sinatra::Base
  get '/info' do
    'HELLO API-WORLD'
  end

  put '/api/Calendars' do
    # expects json body
    # of format { name: String, date: String }
    begin
      data = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422
    end
    name = data['name']
    date = data['date']

    halt 422 if name.nil? || date.nil?  # unprocessable entity

    date = parse_date(date)

    halt 422 if date.nil?

    # all is well
    id = DB[:events].insert(name: name, date: date)

    if id.nil?
      halt 500
    else
      { id: id, name: name, date: date }.to_json
    end
  end

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
  rescue ArgumentError
    nil
  end
end

use MainController
