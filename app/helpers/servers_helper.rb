module ServersHelper

  def server_state_bulb(server)
    content_tag :span, nil,
      title: server.state,
      class: ["server-state-bulb", "is-#{server.state}"]
  end

  def large_server_state_bulb(server)
    content_tag :span, nil,
      title: "Server is #{server.state}",
      class: ["server-state-bulb", "server-state-bulb-large", "is-#{server.state}"]
  end

  def can_create_shared_servers?(user, funpack)
    user.minecraft_linked? and funpack.game.shared_servers?
  end

end
