module ApplicationHelper

  def title(page_title)
    provide(:title, page_title.to_s)
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

  def fuck_you_select_bitch(form, field, value, default)
    if form.object.send(field) == value
      true
    else
      default
    end
  end

  def fuck_you_checkbox_cunt(form, field, default)
    if form.object.send(field).present?
      form.object.send(field) == '1'
    else
      default
    end

  def flip
    $flipper
  end

end
