class UserMailer < ActionMailer::Base
  include Resque::Mailer
  add_template_helper(ActionView::Helpers::DateHelper)

  def welcome(user_id)
    @user = User.find(user_id)
    mail to: @user.email,
         subject: 'Welcome to Minefold!'
  end


  def credit_reminder(user_id)
    @user = User.find(user_id)

    track(@user, 'sent credit reminder email')
    mail to: @user.email,
         subject: "Time for Minefold Pro"
  end


  def credit_reset(user_id)
    @user = User.find(user_id)

    track(@user, 'sent credit reset email')
    mail to: @user.email,
         subject: 'You have more Minefold time!'
  end


  def membership_created(user_id, world_id, op_id)
    @user = User.find(user_id)
    @world = World.find(world_id)
    @op = User.find(op_id)

    mail to: @user.email,
         subject: "#{@op.username} has added you to #{@world.fullname}"
  end


  def membership_request_approved(user_id, world_id, op_id)
    @user = User.find(user_id)
    @world = World.find(world_id)
    @op = User.find(op_id)

    mail to: @user.email,
         subject: "#{@op.username} has let you play in #{@world.fullname}"
  end


  def membership_request_created(user_id, world_id, request_id)
    @user = User.find(user_id)
    @world = World.find(world_id)
    @request = @world.membership_requests.find(request_id)

    mail to: @user.email,
         subject: "#{@request.player.username} would like to play in #{@world.fullname}"
  end


  def world_started(user_id, world_id)
    @world = World.find(world_id)
    @user = User.find(user_id)

    @user.last_world_started_mail_sent_at = Time.now
    @user.save

    mail to: @user.email,
         subject: "Your friends are playing on Minefold in #{@world.name}"
  end


  def world_deleted(user_id, world_name, world_creator_username)
    @user = User.find(user_id)
    @world_name = world_name
    @world_creator_username = world_creator_username

    mail to: @user.email,
         subject: "#{@world_creator_username} removed the world #{@world_name} you were playing in"
  end

  def world_comment_added(user_id, world_id, comment_id)
    @user = User.find(user_id)
    @world = World.find(world_id)
    @comment = @world.comments.find(comment_id)

    mail to: @user.email,
         subject: "[#{@world.name_with_creator}] #{@comment.text.truncate(60)}"
  end


# ---


  class Preview < ::MailView
    def welcome
      user = User.dave

      UserMailer.welcome(user.id)
    end

    def credit_reminder
      user = User.dave

      UserMailer.credit_reminder(user.id)
    end

    def credit_reset
      user = User.dave

      UserMailer.credit_reset(user.id)
    end

    def membership_created
      user = User.dave
      op = User.chris
      world = World.find_by(name: 'minebnb', creator_id: op.id)

      UserMailer.membership_created(user.id, world.id, op.id)
    end

    def membership_request_approved
      user = User.dave
      op = User.chris
      world = World.find_by(name: 'minebnb', creator_id: op.id)

      UserMailer.membership_request_approved(user.id, world.id, op.id)
    end

    def membership_request_created
      user = User.chris
      world = World.find_by(name: 'minebnb', creator_id: user.id)
      request = world.membership_requests.last

      UserMailer.membership_request_created(user.id, world.id, request.id)
    end

    def world_started
      user = User.chris
      world = World.find_by(name: 'minebnb', creator_id: user.id)

      UserMailer.world_started(user.id, world.id)
    end
    
    def world_comment_added
      user = User.chris
      world = World.find_by(name: 'minebnb', creator_id: user.id)
      comment = world.comments.last
      
      UserMailer.world_comment_added(user.id, world.id, comment.id)
    end
  end

private

  def track(user, event)
    Mixpanel.track(event, distinct_id: user.distinct_id.to_s)
  end

end
