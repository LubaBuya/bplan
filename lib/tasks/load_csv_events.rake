require 'csv'
require 'json'

namespace :admin do
  desc "Populate groups from data/group_colors.json"
  task :load_groups => :environment do
    L = JSON.parse(open('data/group_colors.json').read)
    
    L.each do |name, color|
      g = Group.find_by_name(name)
      if g.blank?
        Group.create(name: name, color: color)
      else
        g.color = color
        g.save
      end
    end
  end
  
  desc "Populate events from data/events.csv"
  task :load_events => :environment do
    Rake::Task["admin:load_groups"].invoke
    
    #deleting all events previously in db. Map is a function
    #for an enumerable. This is Event.all.map {|x| x.delete }
    Event.all.map(&:delete)


    CSV.foreach('data/events.csv', headers: true) do |row|

      e = row.to_hash

      group = Group.find_by_name(e['group'])

      # just prinitng everything on console
      puts e['title']

      Time.zone = 'Pacific Time (US & Canada)' 
      
      v = {
        title: e['title'],
        event_type: e['event_type'],
        start_at: Time.parse(e['start_at'] + '-0800').in_time_zone(Time.zone),
        end_at: Time.parse(e['end_at'] + '-0800').in_time_zone(Time.zone),
        location: e['location'],
        description: e['details'],
        group_id: group.id
      }
      Event.create(v)
    end
  end
end
