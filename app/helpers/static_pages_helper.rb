module StaticPagesHelper

	def big_event_style(e)
		"border: 2px solid #{e.group.color};"
	end

	    #"border: 1px solid #{group.color};" +	
	    def group_style(group)
	    	"border-left: 12px solid #{group.color};"
	    end

	    def combineGroups

	    end

  # cutoff for number of letters at which we put location on new line
  LOCATION_CUTOFF = 40

end
