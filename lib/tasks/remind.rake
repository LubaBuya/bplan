require 'twilio-ruby'

namespace :admin do
  desc "Remind people by email"
  task :remind_emails => :environment do
    d = Time.now
    favs = FavoriteEvent.where(email: true)
    if favs.blank?
      exit
    end
    
    events = favs.map {|x| [x.event, x.user]}
    
    events = events.select {|event, user|
      user.remind_email > 0 &&
      d > event.start_at - user.remind_email - 30.seconds &&
      d < event.start_at - user.remind_email + 10.minutes
    }

    events.each do |e, u|
      puts "Reminding %s of %s" % [u.email, e.title]
      UserMailer.event_reminder(e, u).deliver
    end
  end

  desc "Remind people by sms"
  task :remind_sms => :environment do
    d = Time.now
    favs = FavoriteEvent.where(sms: true)
    if favs.blank?
      exit
    end
    
    events = favs.map {|x| [x.event, x.user]}
    
    events = events.select {|event, user|
      user.remind_sms > 0 &&
      d > event.start_at - user.remind_sms - 30.seconds &&
      d < event.start_at - user.remind_sms + 10.minutes &&
      !user.phone_number.blank?
    }

    @client = Twilio::REST::Client.new(Bplan::Application.config.twilio_sid,
                                       Bplan::Application.config.twilio_token)

    events.each do |e, u|
      puts "Reminding %s of %s" % [u.phone_number, e.title]
      body = "Event at %s in %s:\n%s" % [ e.start_at.strftime('%I:%M %P'),
                                          e.location,
                                          e.title ]

      @client.account.messages
        .create(
                {
                  :from => Bplan::Application.config.twilio_phone_number,
                  :to => u.phone_number,
                  :body => body
                })

    end
  end

  desc "Remind people by sms and email"
  task :remind_all => :environment do
    Rake::Task["admin:remind_sms"].invoke
    Rake::Task["admin:remind_emails"].invoke
  end
  

end
