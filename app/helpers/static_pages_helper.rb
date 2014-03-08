module StaticPagesHelper

  def big_event_style(e)
    "border: 2px solid #{@gcols[e.group_id]};"
  end

  def group_style(group)
    #"border: 1px solid #{group.color};" +
    "border-left: 12px solid #{group.color};"
  end

  # cutoff for number of letters at which we put location on new line
  LOCATION_CUTOFF = 30
<<<<<<< HEAD
=======
  LOCATION_CUTOFF_MAIL = 25
>>>>>>> 340bc6d672b220a4d41c98fb4c538d4d9b7f4a88

end
