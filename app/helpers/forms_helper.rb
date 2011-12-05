module FormsHelper

  def error_messages_for(object, field)
    errors = object.errors[field]
    if errors and not errors.empty?
      content_tag(:div, errors.to_sentence, class: 'errors')
    end
  end

end
