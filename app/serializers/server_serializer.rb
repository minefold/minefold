class ServerSerializer < Serializer

  def payload
    o = super
    o[:name] = object.name
    o[:state] = object.display_state.to_s

    o[:created] = object.created_at
    o[:updated] = object.updated_at

    if object.display_state == :up
      o[:uptime] = Time.now.to_i - object.created_at.to_i
      o[:address] = object.address.to_s
    end

    o
  end

end
