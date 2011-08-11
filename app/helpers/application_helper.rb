# encoding: utf-8

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
  
  
  def template(name, &block)
    @_templates ||= []
    content = wrap_template(name, &block) if block_given?
    unless @_templates.include? name
      @_templates << name
      content_for :templates, content if content
    end
  end
  
  def wrap_template(name, &block)
    html = <<-HTML
    <script id="template-#{name}" type="text/html">
      #{capture_haml(&block).html_safe}
    </script>
    HTML
    html.html_safe
  end
  
  

end
