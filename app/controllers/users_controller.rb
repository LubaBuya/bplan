  class UsersController < ApplicationController

    include UsersHelper
    
    def new
      @user = User.new
    end

    # def show
    #   @user = User.find(params[:id])
    # end

    def login
      @user = User.new
    end

    def logout
      cookies.delete :current_user
      redirect_to :root
    end
    
    def create
      params = user_params
      # params[:password_confirmation] = params[:password]
      puts params
      @user = User.new(params)
      @user.save
      
      if @user.errors.empty?
        save_user_to_cookie(@user)
        render json: {
          errors: @user.nice_messages,
          success: true
        }
      else
        render json: {
          errors: @user.nice_messages,
          success: false
        }
      end
    end

    def login_post
      user = User.find_by_email(params[:user][:email].downcase)
      if user && user.authenticate(params[:user][:password])
        save_user_to_cookie(user)
        render json: {
          success: true,
          errors: []
        }
      else
        render json: {
          success: false,
          errors: ['Email or password invalid']
        }
      end
    end

    
    REMINDER_TIMES =  {
      "never" => 0,
      "1day" => 1.day,
      "1hour" => 1.hour,
      "30min" => 30.minutes,
      "15min" => 15.minutes
    }

    
    TIMES_REMINDER =  {
      0 => "never",
      1.day.to_i => "1day",
      1.hour.to_i => "1hour",
      30.minutes.to_i => "30min",
      15.minutes.to_i => "15min"
    }

    def preferences
      @user = current_user
      if @user.blank?
        redirect_to :root
        return
      end

      @user_groups = Set.new(@user.groups.map(&:id))

      @reminder_choices = [["Never", "never"],
                           ["1 day before", "1day"],
                           ["1 hour before", "1hour"],
                           ["30 minutes before", "30min"],
                           ["15 minutes before", "15min"]]

      
      
      @remind_email = TIMES_REMINDER.fetch(@user.remind_email, "30min")
      @remind_sms = TIMES_REMINDER.fetch(@user.remind_sms, "30min")
      
    end

    def update_groups
      ids = Set.new(params[:group_ids].map(&:to_i))

      @user = current_user
      if @user.blank?
        render json: {
          success: false,
          errors: ["nobody is logged in"]
        }
        return
      end

      
      groups = Set.new(@user.groups.map(&:id))

      to_remove = groups.difference(ids)
      to_add = ids.difference(groups)
      
      for id in to_remove
        s = Subscription.find_by_group_id_and_user_id(id, @user.id)
        s.delete
      end

      for id in to_add
        s = Subscription.create({user_id: @user.id, group_id: id})
      end

      render json: {
        success: true,
        errors: []
      }
    end

    
    
    def update_reminders
      puts params

      @user = current_user
      if @user.blank?
        render json: {
          success: false,
          errors: ["nobody is logged in"]
        }
        return
      end

      email = params[:reminders][:email]
      sms = params[:reminders][:sms]

      @user.remind_email = REMINDER_TIMES.fetch(email, 0)
      @user.remind_sms = REMINDER_TIMES.fetch(sms, 0)

      @user.save

      @user.phone = params[:phone]
      @user.save
      
      render json: {
        success: true,
        errors: []
      }
    end

    def reminders
      @user = current_user
      if @user.blank?
        redirect_to :root
        return
      end

      Time.zone = 'Pacific Time (US & Canada)'
      d = Time.now.in_time_zone(Time.zone)

      @events = FavoriteEvent.where(user_id: @user.id).map {|x| [x.event, x]}
      @events = @events.select {|x| x[0].end_at > d &&
        (x[1].email || x[1].sms || x[1].gcal) }
      @events = @events.sort_by {|x| x[0].start_at }

      @gnames, @gcols = Group.groups_hash
      
    end
    
    def user_groups
      user = current_user
      if user.blank?
        render json: {
          groups: [],
          remind_email: "never",
          remind_sms: "never"
        }
      else
        render json: {
          groups: user.groups.map(&:id),
          remind_email: TIMES_REMINDER.fetch(user.remind_email, "never"),
          remind_sms: TIMES_REMINDER.fetch(user.remind_sms, "never")
        }
      end
    end

    def test_sms
    end

    def test_email
      u = current_user
      if u.blank?
        render json: {
          success: false
        }
        return
      end
      g = Group.find_by_name("EECS")

      Time.zone = 'Pacific Time (US & Canada)'
      
      e = Event.new(title: "ucbplan Email Test Event",
                    start_at: Time.now,
                    end_at: Time.now + 1.hour,
                    location: "Soda hall", group_id: g.id,
                    description: "This is just a test event. Seems like you got it!")

      Thread.new do
        UserMailer.event_reminder(e, u).deliver
      end

      render json: {
        success: true
      }

    end

    def test_sms
      u = current_user
      if u.blank?
        render json: {
          success: false
        }
        return
      end
      g = Group.find_by_name("EECS")

      Time.zone = 'Pacific Time (US & Canada)'
      
      e = Event.new(title: "ucbplan SMS Test Event",
                    start_at: Time.now,
                    end_at: Time.now + 1.hour,
                    location: "Soda hall", group_id: g.id,
                    description: "This is just a test event. Seems like you got it!")

      Thread.new do
        @client = Twilio::REST::Client.new(Bplan::Application.config.twilio_sid,
                                           Bplan::Application.config.twilio_token)

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

      render json: {
        success: true
      }

    end

    private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    
  end
