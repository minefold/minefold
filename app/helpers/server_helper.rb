module ServerHelper

  def control_state(server)
    if server.playable?
      :playable
    elsif server.starting?
      :starting
    else
      :idle
    end
  end

end
