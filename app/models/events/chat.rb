class Events::Chat < Event
  field :text

  def msg
    "<#{source.username}> #{text}"
  end
end