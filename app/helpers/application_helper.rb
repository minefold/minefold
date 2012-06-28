module ApplicationHelper

  def title(page_title)
    provide(:title, page_title.to_s)
  end

  def layout(*layouts)
    @layouts = layouts.map {|l| "l-#{l}"}
  end

  def hidden
    {style: 'display:none'}
  end

end
