# encoding: utf-8

module ApplicationHelper

  def title(page_title, suffix="")
    provide(:title, "#{page_title} – Minefold #{suffix}")
  end

  def desc(meta_description)
    provide(:meta_description, meta_description.to_s)
  end

  def layout(*layouts)
    @layouts = layouts.map {|l| "l-#{l}"}
  end

  def hidden
    {style: 'display:none'}
  end

end
