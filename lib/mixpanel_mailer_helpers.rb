module MixpanelMailerHelpers

  def track(distinct_id, event, properties={})
    MixpanelAsync.track(distinct_id, event, properties)
  end

end
