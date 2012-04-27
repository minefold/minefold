module MixpanelHelper
  
  def register_once(properties)
    code = "mixpanel.register_once(#{properties.to_json});".html_safe
    haml_tag('script', code)
  end

  def track(name, properties={})
    code = "mixpanel.track(#{name.to_json}, #{properties.to_json});".html_safe
    haml_tag('script', code)
  end

  def track_pageview(properties={})
    extras = ""
    if properties.any?
      extras = ", #{properties.to_json[1..-2]}"
    end
    
    code = %Q{mixpanel.track('page viewed', {"page name":document.title, "url":window.location.pathname#{extras}});}.html_safe
    haml_tag('script', code)
  end
end
