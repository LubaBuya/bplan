require 'csv'
require 'json'

namespace :admin do
  desc "Populate venues with CSV data from Songkick and Google"
  task :load_csv_events => :environment do

    L = JSON.parse(open('data/group_colors.json').read)
    L.each do |name, color| Group.create(name: name, color: color); end
    
    count = 0
    CSV.foreach('data/events.csv', headers: true) do |row|
      break if count > 1000
      count += 1
      e = row.to_hash

      group = Group.find_by_name(e['group'])

      puts e['title']
      
      v = {
        title: e['title'],
        event_type: e['event_type'],
        start_at: Time.parse(e['start_at']),
        end_at: Time.parse(e['end_at']),
        location: e['location'],
        description: e['details'],
        group_id: group.id
      }
      Event.create(v)
    end
  end
end
