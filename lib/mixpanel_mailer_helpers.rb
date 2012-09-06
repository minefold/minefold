module MixpanelMailerHelpers

  def track(user, event, options={})
    Mixpanel.track(event, options.merge(distinct_id: user.id.to_s))
  end

end
