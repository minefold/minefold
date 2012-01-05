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

  def title(page_title, masthead_title=page_title, &blk)
    content_for :title, page_title.to_s
    if block_given?
      masthead &blk
    else
      content_for :masthead, content_tag(:h1, masthead_title)
    end
  end

  def head(&blk)
    content_for :head, capture_haml(&blk)
  end

  def masthead(&blk)
    content_for :masthead, capture_haml(&blk)
  end

  def before(&blk)
    content_for :before, &blk
  end

  def after(&blk)
    content_for :after, &blk
  end
end
