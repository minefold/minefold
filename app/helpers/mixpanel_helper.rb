module MixpanelHelper

  def track(name, properties={})
    js = "mixpanel.track(#{name.to_json}, #{properties.to_json});"
    haml_tag(:script, js.html_safe)
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
      'credits' => current_user.credits
    }
  end

end
