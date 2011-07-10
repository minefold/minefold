module ApplicationHelper

  def page_css_selector
    {
      id: "#{params[:controller]}_#{params[:action]}",
      class: [params[:controller], params[:action]]
    }
  end

  def hidden
    {style: 'display:none'}
  end

end
