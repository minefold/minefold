class WorldMailer < ActionMailer::Base
  include Resque::Mailer

  default from: 'team@minefold.com'
  layout 'email'

  def play_request world_id, requestor_id
    @world     = World.find(world_id)
    @owner     = @world.creator
    @requestor = User.find(requestor_id)

    mail   to: @owner.email,
      subject: "#{@requestor.username} would like to play in #{@world.name}"
  end

  class Preview < MailView
    def play_request
      ::WorldMailer.play_request(World.default.id,
                                 User.dave.id)
    end
  end
end
