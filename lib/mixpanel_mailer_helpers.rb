module MixpanelMailerHelpers

  def track(user, event, options={})
    Mixpanel.async_track(event, options.merge(distinct_id: user.distinct_id))
  end

end
