require 'sinatra'

get '/info' do
  'HELLO API-WORLD'
end

put '/event' do
  # TODO: implement
  'EVENT ENDPOINT'
end

get '/timeToDate/:event_name' do
  event_name = params[:event_name]
  # TODO: implement
  'TIME TO DATE ENDPOINT'
end
