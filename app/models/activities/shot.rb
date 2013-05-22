class Activities::Shot < Activity

  def self.for(shot)
    new(actor: shot.uploader, subject: shot, target: shot.server)
  end

end
