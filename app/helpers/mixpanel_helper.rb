module MixpanelHelper
  def track_pageview
    if Rails.env.production?
      code = "mpq.track('page viewed', {'page name':document.title, 'url':window.location.pathname});"
      head {haml_tag('script', code)}
    end
  end
end
