module MixpanelMailerHelpers

  def track(user, event, options={})
    Mixpanel.track_async(event, options.merge(distinct_id: user.distinct_id))
  end

end
