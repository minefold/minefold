# encoding: utf-8

module ApplicationHelper

  def page_css_selector
    [params[:controller].gsub('/', '-').dasherize,
     params[:action].dasherize].join('-')
  end

  def hidden
    {style: 'display:none'}
  end

  def template(name, options)
    view = Mustache.new
    view.template_name = name.to_sym

    contexts = [*(options[:object] || options[:collection] || [])]

    capture_haml do
      contexts.each do |ctx|
        haml_concat view.render(view.template, ctx).html_safe
      end unless contexts.empty?

      haml_tag(:script, {type: 'text/x-mustache', data: {name: name}}) do
        haml_concat view.template.source
      end
    end
  end

  def flash_upload_options(opts)
    { buttonUpPath: image_path('upload-button.png'),
      buttonOverPath: image_path('upload-button-hover.png'),
      buttonDownPath: image_path('upload-button-down.png'),
      fileTypes: '*.zip',
      fileTypeDescs: 'Zip Archives',
      selectMultipleFiles: false,
      buttonWidth: 100
    }.merge(opts)
  end

  def time_ago(time, options = {})
    options[:class] ||= 'timeago'
    content_tag(:abbr, time.to_s, options.merge(:title => time.getutc.iso8601))
  end

  def youtube_vid
    content_tag(:iframe, nil, width: 480, height: 390, src: "#{Videos.sample}?rel=0", frameborder: 0, allowfullscreen: true).html_safe
  end

  def title page_title, masthead_title=page_title, &blk
    content_for :title, page_title.to_s
    if block_given?
      masthead &blk
    else
      content_for :masthead, content_tag(:h1, masthead_title)
    end
  end

  def masthead &blk
    content_for :masthead, capture_haml(&blk)
  end

  def subhead &blk
    content_for :subhead, capture_haml(&blk)
  end

  def before &blk
    content_for :before, &blk
  end

  def after &blk
    content_for :after, &blk
  end

  def current_user_needs_help?
    current_user.first_sign_in? and
    not (
      current_user.current_world or
      not current_user.whitelisted_worlds.empty?
    )
  end

end
