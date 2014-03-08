class StaticPagesController < ApplicationController
  require 'will_paginate/array'
  # WillPaginate.per_page = 20

  include UsersHelper

  def index
    Time.zone = 'Pacific Time (US & Canada)'
    d = Time.now.in_time_zone(Time.zone)

    # EVENTS TODAY
    
<<<<<<< HEAD
    @gnames, @gcols = Group.groups_hash

    # selecting only events that are today. First getting events that are today. Then we are sorting it by comparing each one?
    @events_today = Event.order(:start_at).select {|x| x.end_at > d && x.end_at <= d.at_end_of_day }
    
    #testing
    #puts @events_today
=======
    @events_today = Event.where(end_at: d..d.at_end_of_day).order(:start_at, :title)
>>>>>>> a9bf1577470f8fe4831ff87946676089161dc7e8

    @left_name = "Today"
    @user = current_user
    
    if not @user.blank?
      groups = @user.groups.map(&:id)
      @events_today = @events_today.where(group_id: groups)
    end

    @gnames, @gcols = Group.groups_hash
    
    if @events_today.length == 0
      d = (d + 1.day).at_beginning_of_day
      @events_today = Event.where(end_at: d..d.at_end_of_day).order(:start_at)
      @left_name = "Tomorrow"

      if not @user.blank?
        @events_today = @events_today.where(group_id: groups)
      end

    end

    #@events_today = @events_today.group(:title)
    # @events_today = @events_today.select('DISTINCT ON (events.title, events.start_at) *')

    @events_today = @events_today.group_by{|x| [x.title, x.start_at]}.values
    @events_today = @events_today.map { |x| x.sort_by  { |x| @gnames[x.group_id] } }

    
    # UPCOMING EVENTS

    
    @events_upcoming = Event.where('end_at > :now', {now: d.at_end_of_day}).order(:start_at)

    if not @user.blank?
      @events_upcoming = @events_upcoming.where(group_id: groups)
    end

    #@events_upcoming = @events_upcoming.group(:title)
    #@events_upcoming = @events_upcoming.select('DISTINCT ON (events.title, events.start_at) *')
    
    @events_upcoming = @events_upcoming.group_by{|x| [x.title, x.start_at]}.values
    @events_upcoming = @events_upcoming.map { |x| x.sort_by { |x| @gnames[x.group_id] } }

    
    @events_upcoming = @events_upcoming.paginate(page: params[:page], per_page: 20)
  end


  def about
    # Thread.new do
    #   UserMailer.events_today().deliver
    # end
  end

  
end
