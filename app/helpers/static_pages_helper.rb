module StaticPagesHelper

  def big_event_style(e)
    "border: 1px solid #{e.group.color};" +
    "border-left: 8px solid #{e.group.color};"
  end

  def group_style(group)
    #"border: 1px solid #{group.color};" +
    "border-left: 12px solid #{group.color};"
  end

end
