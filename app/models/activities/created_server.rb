class Activities::CreatedServer < Activity

  def display_data
    {
      actor_username: actor.username,
      server_name: target.name
    }
  end

end
