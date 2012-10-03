module ServersHelper

  def server_status(server)
    if server.running?
      content_tag :span, nil, class: %w(server-status running)
    else
      content_tag :span, nil, class: %w(server-status)
    end
  end
  
end
