module MixpanelHelper

  def track(event, properties={})
    if Rails.env.production?
      tracking_code = "mpq.track(#{event.to_json}, #{properties.to_json})".html_safe
      head { haml_tag('script', tracking_code)}
    end
  end

end
