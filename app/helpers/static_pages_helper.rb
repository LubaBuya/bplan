module StaticPagesHelper

  def big_event_style(e)
    #"border: 2px solid #{@gcols[e.group_id]};"
    "border: 1px solid #{@gcols[e.group_id]};
border-left: 4px solid #{@gcols[e.group_id]};"
  end

  def group_style(group)
    #"border: 1px solid #{group.color};" +
    "border-left: 12px solid #{group.color};"
  end

  def gcal_link(e)
    s = [e.title, e.start_at.in_time_zone("UTC").iso8601.gsub(/[-:]/, ''),
         e.end_at.in_time_zone("UTC").iso8601.gsub(/[-:]/, ''),
         e.location,
         (e.description || '')[0..1000]]
    
    s = s.map {|x| URI.escape(x) }
    
    'http://www.google.com/calendar/event?action=TEMPLATE&text=%s&dates=%s/%s&location=%s&details=%s' % s
  end
  
  # cutoff for number of letters at which we put location on new line
  LOCATION_CUTOFF = 30
  LOCATION_CUTOFF_MAIL = 25

end
