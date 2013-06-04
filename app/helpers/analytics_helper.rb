module AnalyticsHelper
  def landing_page(type, options={})
    js = <<-EOS
      analytics.track("Viewed landing page", #{options.merge(type: type).to_json});
      analytics.ready(function(){
        window.mixpanel.register_once({"landing type":#{type.to_json} });
      });
    EOS

    content_tag :script, js.html_safe
  end
end
