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

end
