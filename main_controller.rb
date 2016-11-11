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
      now = DateTime.now
      target_time = events.fetch(0).fetch(:date).to_datetime
      diffs = precise_diff(target_time, now)

      { timeToEvent: "#{diffs[0]} Jahre, #{diffs[1]} Monate, #{diffs[2]} Tage, #{diffs[3]} Stunden, #{diffs[4]} Minuten" }.to_json
    rescue IndexError
      halt 404
    end
  end

  private

    def parse_date(string_date)
      Date.parse(string_date)
    end

    # get [year, months, days, hours, minutes] from time diff in seconds
    def precise_diff(to, from)
      years = to.year - from.year
      months = to.month - from.month
      days = to.day - from.day
      hours = to.hour - from.hour
      minutes = to.minute - from.minute

      if minutes < 0
        minutes += 60
        hours -= 1
      end

      if hours < 0
        hours += 24
        days -= 1
      end

      if days < 0
        days += last_day_in_month(months-1)
      end

      if months < 0
        months += 12
        years -= 1
      end


      [years, months, days, hours, minutes]
    end

    def last_day_in_month(month)
      [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month]
    end
end

#use MainController
