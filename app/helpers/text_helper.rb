module TextHelper

  def pluralize_text(count, singular, plural = nil)
    count == 1 ? singular : (plural || singular.pluralize)
  end

  def markdown(text)
    RDiscount.new(text).to_html.html_safe
  end

end
