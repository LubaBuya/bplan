class StaticPagesController < ApplicationController
  require 'will_paginate/array'
  # WillPaginate.per_page = 20

  include UsersHelper

  def index
    Time.zone = 'Pacific Time (US & Canada)'
    d = Time.now.in_time_zone(Time.zone)

    # EVENTS TODAY
    
    @events_today = Event.where(end_at: d..d.at_end_of_day).order(:start_at, :title)

    @left_name = "Today"
    @user = current_user
    
    if not @user.blank?
      groups = @user.groups.map(&:id)
      @events_today = @events_today.where(group_id: groups)
    end

    
    if @events_today.length == 0
      d = (d + 1.day).at_beginning_of_day
      @events_today = Event.where(end_at: d..d.at_end_of_day).order(:start_at)
      @left_name = "Tomorrow"

      if not @user.blank?
        @events_today = @events_today.where(group_id: groups)
      end

    end

    #@events_today = @events_today.group(:title)
    @events_today = @events_today.select('DISTINCT ON (events.title, events.start_at) *')


    # UPCOMING EVENTS

    
    @events_upcoming = Event.where('end_at > :now', {now: d.at_end_of_day}).order(:start_at)

    if not @user.blank?
      @events_upcoming = @events_upcoming.where(group_id: groups)
    end

    #@events_upcoming = @events_upcoming.group(:title)
    @events_upcoming = @events_upcoming.select('DISTINCT ON (events.title, events.start_at) *')

    @events_upcoming = @events_upcoming.paginate(page: params[:page], per_page: 20)
  end


  def about
  end

end
