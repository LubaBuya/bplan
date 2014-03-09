class UserMailer < ActionMailer::Base
  default from: "ucbplan"

  def test
    mail(:to => "krchtchk@gmail.com", :subject => "Another test...")
  end

  def events_today
    Time.zone = 'Pacific Time (US & Canada)'
    d = Time.now.in_time_zone(Time.zone)
    d = d.at_beginning_of_day 

    # gnames is the names of the group, gcols is the color
    @gnames, @gcols = Group.groups_hash

    @user = User.find(1)
    groups = @user.groups.map(&:id)
    
    @events_today = Event.where(end_at: d..d.at_end_of_day).order(:start_at, :title)
    @events_today = @events_today.where(group_id: groups)
    
    @events_today = @events_today.group_by{|x| [x.title, x.start_at]}.values
    @events_today = @events_today.map { |x| x.sort_by  { |x| @gnames[x.group_id] } }

    
    mail(:to => "pierre@berkeley.edu",
         :subject => "Events for today")
  end

  helper StaticPagesHelper
  
end
