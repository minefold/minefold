class SessionMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
  
  def started(server_id)
    @server = Server.find(world_id)

    # @user.last_world_started_mail_sent_at = Time.now
    # @user.save

    mail bcc: @server.members.map {|m| m.email }.flatten,
         subject: "Your friends are playing on Minefold in #{@world.name}"
  end
  
end
