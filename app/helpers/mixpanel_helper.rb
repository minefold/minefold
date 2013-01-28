module MixpanelHelper

  def track(event, properties={})
    content_tag :script,
      "mixpanel.track(#{event.to_json}, #{properties.to_json});".html_safe
  end

  def register_once(properties={})
    content_tag :script,
      "mixpanel.register_once(#{properties.to_json});".html_safe
  end

  def track_landing_type(type)
    register_once('landing type' => type.to_s)
  end

  def mixpanel_person
    signed_in? and {
      '$created' => current_user.created_at,
      '$last_login' => current_user.current_sign_in_at,
      '$email' => current_user.email,
      '$first_name' => current_user.first_name,
      '$last_name' => current_user.last_name,
      '$name' => current_user.name,
      '$username' => current_user.username,
      'coins' => current_user.coins,
      'gender' => current_user.gender
    }
  end

end
