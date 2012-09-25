module MixpanelHelper

  def register_once(properties)
    js = "mixpanel.register_once(#{properties.to_json});"
    haml_tag(:script, js.html_safe)
  end

  def track(name, properties={})
    js = "mixpanel.track(#{name.to_json}, #{properties.to_json});"
    haml_tag(:script, js.html_safe)
  end

  # TODO Refactor
  def track_pageview(properties={})
    extras = ""
    if properties.any?
      extras = ", #{properties.to_json[1..-2]}"
    end

    code = %Q{mixpanel.track('page viewed', {"page name":document.title, "url":window.location.pathname#{extras}});}.html_safe
    haml_tag('script', code)
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
