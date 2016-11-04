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
      halt 422
    end
  end

  private

    def parse_date(string_date)
      Date.parse(string_date)
    end

    # get [year, months, days, hours, minutes] from time diff in seconds
    def precise_diff(to, from)
      years = to.year - from.year
      months = to.month - from.month + 12
      days = to.day - from.day
      hours = to.hour - from.hour + 24
      minutes = to.minute - from.minute + 60

      if minutes == 60
        minutes = 0
      else
        hours -= 1
      end

      if hours == 24
        hours = 0
      else
        days -= 1
      end

      if last_day_in_month?(days, to.month - 1)
        days = 0
      else
        months -= 1
      end

      if months == 12
        months = 0
      else
        years -= 1
      end

      [years, months, days, hours, minutes]
    end

    def last_day_in_month?(day, month)
      (month == 2 && (day == 28 || day == 29)) ||
        (day == 30 && [1, 3, 5, 7, 8, 10, 12].includes?(month)) ||
        (day == 31 && [2, 4, 6, 9, 11].includes?(month))
    end
end

use MainController
