require 'sinatra'
require 'json'
require 'date'

get '/info' do
  'HELLO API-WORLD'
end

put '/api/Calendars' do
  # expects json body
  # of format { name: String, date: String }
  data = JSON.parse(request.body.read)
  name = data['name']
  date = data['date']

  halt 422 if name.nil? || date.nil?  # unprocessable entity

  date = parse_date(date)

  halt 422 if date.nil?

  # all is well

  # TODO: save to db
  "created event with name: #{name} and date: #{date}"
end

get '/api/Calendars/timeToDate/:event_name' do
  event_name = params[:event_name]
  # TODO: implement
  'TIME TO DATE ENDPOINT'
end

def parse_date(string_date)
  Date.parse(string_date)
rescue ArgumentError
  nil
end
