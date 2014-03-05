class StaticPagesController < ApplicationController
    require 'will_paginate/array'
    WillPaginate.per_page = 10

  def index
    Time.zone = 'Pacific Time (US & Canada)'
    #d = Time.new(2014, 03, 1)
    d = Time.now.in_time_zone(Time.zone)
    # d = d.at_beginning_of_day + 2
    
    # selecting only events that are today. First getting events that are today. Then we are sorting it by comparing each one?
    @events_today = Event.all.select {|x| x.end_at > d && x.end_at <= d.at_end_of_day }
    .sort {|a,b| a.start_at <=> b.start_at }.paginate(page: params[:events_today_page])
    @events_upcoming = Event.all.select {|x| x.end_at > d.at_end_of_day }
    .sort {|a,b| a.start_at <=> b.start_at }.paginate(page: params[:page])
  # @events = Event.paginate(page: params[:page])
  end

  def previous_events
  end

end