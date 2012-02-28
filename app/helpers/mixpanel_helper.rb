module MixpanelHelper

  def track(name, properties={})
    code = "mpq.track(#{name.to_json}, #{properties.to_json});".html_safe
    haml_tag('script', code)
  end

  def track_pageview
    code = "mpq.track('page viewed', {'page name':document.title, 'url':window.location.pathname});".html_safe
    haml_tag('script', code)
  end
end
