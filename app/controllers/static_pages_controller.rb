class StaticPagesController < ApplicationController
  require 'will_paginate/array'
  # WillPaginate.per_page = 20

  include UsersHelper

  def index
    Time.zone = 'Pacific Time (US & Canada)'
    d = Time.now.in_time_zone(Time.zone)

    @left_name = "Today"
    @user = current_user
    @logged = not(@user.blank?)
    @new_fav = FavoriteEvent.new

    # EVENTS TODAY
    @events_today = Event.where(end_at: d..d.at_end_of_day).order(:start_at, :title)

    
    if @logged
      # same as groups = user.groups.map{|x| x.id }
      groups = @user.groups.map(&:id)
      # selecting only groups if the user
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

    # For duplicates: grouping events by title and start time.  @events_today is now a hash of hashes
    @events_today = @events_today.group_by{|x| [x.title, x.start_at]}.values
    # order these inner hashes
    @events_today = @events_today.map { |x| x.sort_by { |x| @gnames[x.group_id] } }

    
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

    @logged = false
  end


  def about
    # Thread.new do
    #   UserMailer.events_today().deliver
    # end
  end

  
end
