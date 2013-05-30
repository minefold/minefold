module AnalyticsHelper
  def landing_page(type, options={})
    js = "analytics.track('Viewed landing page', #{options.merge(type: type).to_json});"

    content_tag :script, js.html_safe
  end
end
