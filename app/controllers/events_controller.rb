class EventsController < ApplicationController
  include UsersHelper
  
  def show
    @event = Event.where(id: params[:id])[0]
    if @event.blank?
      redirect_to :root
      return
    end
    
    @user = current_user
    @gnames, @gcols = Group.groups_hash

    if not @user.blank?
      @favorite = FavoriteEvent.where(user_id: @user.id, event_id: @event.id)[0]
      @favorite ||= FavoriteEvent.new(event_id: @event.id, user_id: @user.id)
    end
    
    puts @event
  end

end
