module ApplicationHelper

  def hidden
    {style: 'display:none'}
  end

  def page_css_id
    [ params[:controller].gsub('/', '-').dasherize,
      params[:action].dasherize ].join('-')
  end

  def page_css_class
    [params[:controller], 'controller'].join('-')
  end

  def app_html_attrs
    {
      id: page_css_id,
      class: page_css_class,
      xmlns: 'http://www.w3.org/1999/xhtml',
      dir: 'ltr',
      lang: 'en-US',
      'xmlns:fb' => 'https://www.facebook.com/2008/fbml'
    }
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

  def title(page_title)
    content_for(:title, page_title.to_s)
  end

  def head(&blk)
    content_for :head, capture_haml(&blk)
  end

  def masthead(attrs={}, &blk)
    html = content_tag(:section,
      content_tag(:div, capture(&blk), class: 'container'),
      attrs.merge(id: 'masthead'))

    content_for :masthead, html
  end

  def js(&blk)
    content_for :js, capture(&blk)
  end

  def crashmat_options
    opts = {
      key: "2",
      debug: !Rails.env.production?,
    }
    if signed_in?
      opts[:user] = {id: current_user.id, email: current_user.email}
    end
    opts
  end

end
