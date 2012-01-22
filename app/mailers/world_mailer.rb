class WorldMailer < ActionMailer::Base
  include Resque::Mailer

  include WorldHelper
  helper :world

  default from: 'Minefold <team@minefold.com>'

  def membership_created(world_id, membership_id)
    @world = World.find(world_id)
    @creator = @world.creator
    @membership = @world.memberships.find(membership_id)
    @user = @membership.user

    mail to: @user.email,
         subject: "You can now play in #{@world.name}"
  end

  def membership_request_created(world_id, request_id)
    @world = World.find(world_id)
    @creator = @world.creator
    @user = @world.membership_requests.find(request_id).user

    @world.ops.each do |op|
      mail to: op.email,
           subject: "#{@user.username} would like to play in #{@world.name}"
    end
  end

  def membership_request_approved(world_id, user_id)
    @world = World.find(world_id)
    @creator = @world.creator
    @user = User.find(user_id)

    mail to: @user.email,
         subject: "#{@creator.username} has added you to #{@world.name}"
  end

  def world_started(world_id, user_id)
    @world  = World.find(world_id)
    @user = User.find(user_id)

    @recent_events = @world.events.where(_type: 'Chat').limit(5)

    mail to: @user.email,
         subject: "Your friends are playing on Minefold in #{@world.name}"
  end
end
