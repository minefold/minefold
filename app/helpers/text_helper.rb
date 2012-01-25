module TextHelper

  def pluralize_text(count, singular, plural = nil)
    count == 1 ? singular : (plural || singular.pluralize)
  end

end
