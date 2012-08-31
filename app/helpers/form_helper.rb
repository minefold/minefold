module FormHelper

  def error_message_for(object, *fields)
    return if object.errors.empty?

    errors = fields.map {|field| object.errors[field] }.flatten.compact
    if errors.any?
      content_tag(:span, errors.to_sentence, class: 'help-inline')
    end
  end

end
