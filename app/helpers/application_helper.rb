# encoding: utf-8

module ApplicationHelper

  def page_css_selector
    [params[:controller].gsub('/', '-').dasherize,
     params[:action].dasherize].join('-')
  end

  def hidden
    {style: 'display:none'}
  end

  def time_left_in_worlds user
    "#{user.hours}:#{user.minutes}"
  end

  def template(name, options)
    view = Mustache.new
    view.template_name = name.to_sym

    contexts = [*(options[:object] || options[:collection])]

    capture_haml do
      contexts.each do |ctx|
        haml_concat view.render(view.template, ctx).html_safe
      end unless contexts.empty?

      haml_tag(:script, {type: 'text/x-mustache', data: {name: name}}) do
        haml_concat view.template.source
      end
    end
  end

  # def template(name, &block)
  #   @_templates ||= []
  #   content = wrap_template(name, &block) if block_given?
  #   unless @_templates.include? name
  #     @_templates << name
  #     content_for :templates, content if content
  #   end
  # end
  #
  # def wrap_template(name, &block)
  #
  #
  #   html = <<-HTML
  #   <script id="template-#{name}" type="text/html">
  #     #{capture_haml(&block).html_safe}
  #   </script>
  #   HTML
  #   html.html_safe
  # end

  def flash_upload_options(opts)
    { buttonUpPath: image_path('upload-button.png'),
      buttonOverPath: image_path('upload-button-hover.png'),
      buttonDownPath: image_path('upload-button-down.png'),
      fileTypes: '*.zip',
      fileTypeDescs: 'Zip Archives',
      selectMultipleFiles: false,
      buttonWidth: 100
    }
  end

end
