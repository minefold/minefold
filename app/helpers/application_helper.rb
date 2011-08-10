module ApplicationHelper

  def page_css_selector
    list = [params[:controller].gsub('/', '-').dasherize,
          params[:action].dasherize]
    { id: list.join('-'),
      class: list }
  end

  def hidden
    {style: 'display:none'}
  end
  
  def credits_in_words minutes
    case
    when minutes < 60
      pluralize minutes, "minute", "minutes"
    else
      pluralize (minutes / 60), "hour", "hours"
    end
  end
  

end
