module ApplicationHelper

  def hidden
    {style: 'display:none'}
  end

  def page_css_selector
    [params[:controller].gsub('/', '-').dasherize,
     params[:action].dasherize].join('-')
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

  def youtube_vid
    content_tag(:iframe, nil,
      width: 480,
      height: 390,
      src: "#{Videos.sample}?rel=0",
      frameborder: 0,
      allowfullscreen: true,
      class: 'youtube'
    ).html_safe
  end

  def title(page_title)
    content_for(:title, page_title.to_s)
  end

  def title_and_masthead(name)
    title(name)
    masthead { content_tag(:h1, name) }
  end

  def title_and_masthead(name)
    title(name)
    masthead { content_tag(:h1, name) }
  end
  
  def head(&blk)
    content_for :head, capture_haml(&blk)
  end

  def masthead(attrs={}, &blk)
    attrs = {id: 'masthead'}.merge!(attrs)
    content = content_tag(:section, capture(&blk), attrs)

    content_for :masthead, content
  end

  def backside(&blk)
    content_for :backside, capture_haml(&blk)
  end

end
