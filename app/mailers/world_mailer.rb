class WorldMailer < ActionMailer::Base
  include Resque::Mailer

  include WorldHelper
  helper :world

  def membership_created(world_id, op_id, new_user_id)
    @world = World.find(world_id)
    @op = User.find(op_id)
    @new_user = User.find(new_user_id)

    return unless @new_user.notify? :world_membership_added

    mail to: @new_user.email,
         subject: "You've been added to #{@world.host}"
  end

  def membership_request_created(world_id, request_id, op_id)
    @world = World.find(world_id)
    @creator = @world.creator
    @membership = @world.membership_requests.find(request_id)
    @player = @membership.user.minecraft_player
    @user = @player.user
    if @user
      @op = User.find op_id

      return unless @op.notify? :world_membership_request_created

      mail to: @op.email,
           subject: "#{@user.username} would like to play in #{@world.name}"
    end
  end

  def membership_request_approved(world_id, op_id, user_id)
    @world = World.find(world_id)
    @op = User.find(op_id)
    @new_user = User.find(user_id)

    return unless @new_user.notify? :world_membership_added

    mail to: @new_user.email,
         subject: "#{@op.minecraft_player.username} has approved your request to play"
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
