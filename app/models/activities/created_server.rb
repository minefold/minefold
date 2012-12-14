class Activities::CreatedServer < Activity

  def self.for(server)
    new(actor: server.creator, target: server)
  end

end
