class StaticPagesController < ApplicationController

  def index
    Time.zone = 'Pacific Time (US & Canada)' 
    d = Time.now
    d  = d - 1
    d = d.at_beginning_of_day
    
    @events_today = Event.all.select {|x| x.end_at > d && x.end_at <= d.at_end_of_day }.sort {|a,b| a.start_at <=> b.start_at }
    @events_upcoming = Event.all.select {|x| x.end_at > d.at_end_of_day }.sort {|a,b| a.start_at <=> b.start_at }
  end

end
