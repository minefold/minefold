class WorldMailer < ActionMailer::Base
  include Resque::Mailer

  include WorldHelper
  helper :world

  def membership_created(world_id, membership_id)
    @world = World.find(world_id)
    @creator = @world.creator
    @membership = @world.memberships.find(membership_id)
    @user = @membership.user

    return unless @user.notify? :world_membership_added

    mail to: @user.email,
         subject: "You can now play in #{@world.name}"
  end

  def membership_request_created(world_id, request_id, op_id)
    @world = World.find(world_id)
    @creator = @world.creator
    @user = @world.membership_requests.find(request_id).user
    @op = User.find op_id

    return unless @user.notify? :world_membership_request_created

    mail to: @op.email,
         subject: "#{@user.username} would like to play in #{@world.name}"
  end

  def membership_request_approved(world_id, user_id)
    @world = World.find(world_id)
    @creator = @world.creator
    @user = User.find(user_id)

    return unless @user.notify? :world_membership_added

    mail to: @user.email,
         subject: "#{@creator.username} has added you to #{@world.name}"
  end

  def world_started(world_id, user_id)
    @world = World.find(world_id)
    @user = User.find(user_id)
    return if @user.nil?
    return unless @user.notify? :world_started

    @user.last_world_started_mail_sent_at = Time.now
    @user.save

    mail to: @user.email,
         subject: "Your friends are playing on Minefold in #{@world.name}"
  end

  def world_deleted world_name, world_creator, user_id
    @world_name = world_name
    @world_creator = world_creator
    @user = User.find(user_id)

    mail to: @user.email,
         subject: "#{@world_creator} removed the world #{@world_name} you were playing in"
  end
end
