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

  def page_attributes
    { 'xmlns:og' => 'http://ogp.me/ns#',
      id: page_css_id,
      class: page_css_class
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

  def title_and_masthead(name)
    title(name)
    masthead { content_tag(:h1, name) }
  end

  def head(&blk)
    content_for :head, capture_haml(&blk)
  end

  def masthead(attrs={}, &blk)
    content_for :masthead, capture(&blk)
  end

  def js(&blk)
    content_for :js, capture(&blk)
  end

end
