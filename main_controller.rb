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

    begin
      now = Time.now.to_i
      target_time = events.fetch(0).fetch(:date).to_time.to_i
      diffs = break_down_diff(target_time - now)

      { timeToEvent: "#{diffs[0]} Jahre, #{diffs[1]} Monate, #{diffs[2]} Tage, #{diffs[3]} Stunden, #{diffs[4]} Minuten" }.to_json
    rescue IndexError
      halt 422
    end
  end

  private

    def parse_date(string_date)
      Date.parse(string_date)
    end

    # get [year, months, days, hours, minutes] from time diff in seconds
    def break_down_diff(diff_in_seconds)
      seconds_diff = diff_in_seconds

      results = []

      # TODO: not all months have 30 days
      # to minutes, hours, days, months, years
      steps = [60, 60, 24, 30, 12]

      while true
        # x of step size (3 days)
        x = seconds_diff
        steps.each do |step|
          x = x.to_f / step
        end
        results << x.to_i

        y = x.to_i

        steps.each do |step|
          y = y * step
        end

        seconds_diff = seconds_diff - y
        steps.pop
        return results if steps.empty?
      end
    end
end

use MainController
