require 'csv'
require 'json'

namespace :admin do
  desc "Populate groups from data/group_colors.json"
  task :load_groups => :environment do
    puts "Updating groups..."
    
    L = JSON.parse(open('data/group_colors.json').read)
    L = L.sort_by { |x| x[0] }

    
    L.each do |name, color|
      #puts "%-25s %s" % [name, color]

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
    

    fs = FavoriteEvent.all.map { |f|  [f, f.event.externalID] }

    #deleting all events previously in db. Map is a function
    #for an enumerable. This is Event.all.map {|x| x.delete }

    puts "Deleting events..."
    
    Event.all.map(&:delete)


    i = 1
    
    CSV.foreach('data/events.csv', headers: true) do |row|

      e = row.to_hash
      print e
      group = Group.find_by_name(e['group'])

      print "\rLoading event %d..." % i
      $stdout.flush

      if e['details'].blank?
        e['details'] = nil
      end

      tz = Time.zone = 'America/Los_Angeles'

      t1 = Time.zone.parse(e['start_at'])
      t2 = Time.zone.parse(e['end_at'])
      if t1.dst?
        t1 -= 1.hour
        t2 -= 1.hour
      end
      
      v = {
        title: e['title'],
        event_type: e['event_type'],
        start_at: t1,
        end_at: t2,
        location: e['location'],
        description: e['details'],
        group_id: group.id,
        url: e['url'],
        externalID: e['externalID']
      }
      ev = Event.create(v)
      
      i += 1
    end

    puts "\nUpdating reminders..."

    fs.each do |f, eid|
      e = Event.where(externalID: eid)[0]
      if e.blank?
        f.delete
      else
        f.event_id = e.id
        f.save
      end
    end

    puts "Done!"
    
  end

  task :update_events => :environment do
    puts "FETCHING EVENTS..."
    data = `python2 scripts/json_events.py`

    fs = FavoriteEvent.all.map { |f|  [f, f.event.externalID] }
    
    puts "\n\n"
    puts "DELETING EVENTS FROM DATABASE..."
    Event.all.map(&:delete)

    puts "\n\nADDING TO DATABASE..."
    parsed = JSON.load(data)

    i = 1
    
    parsed.each do |e|
      group = Group.find_by_name(e['group'])

      print "\rLoading event %d..." % i
      $stdout.flush
      #puts "%s %s" % [e['group'], e['title']]

      if e['details'].blank?
        e['details'] = nil
      end

      tz = Time.zone = 'America/Los_Angeles'

      t1 = Time.zone.parse(e['start_at'])
      t2 = Time.zone.parse(e['end_at'])
      if t1.dst?
        t1 -= 1.hour
        t2 -= 1.hour
      end
      
      v = {
        title: e['title'],
        event_type: e['event_type'],
        start_at: t1,
        end_at: t2,
        location: e['location'],
        description: e['details'],
        group_id: group.id,
        url: e['url'],
        externalID: e['externalID']
      }
      ev = Event.create(v)

      i += 1
    end

    puts "\nUPDATING REMINDERS..."

    fs.each do |f, eid|
      e = Event.where(externalID: eid)[0]
      if e.blank?
        f.delete
      else
        f.event_id = e.id
        f.save
      end
    end
    

  end
  
end
