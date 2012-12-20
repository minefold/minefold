module FormHelper

  def error_message_for(object, *fields)
    return if object.errors.empty?

    errors = fields.map {|field| object.errors[field] }.flatten.compact
    if errors.any?
      content_tag(:span, errors.to_sentence, class: 'help-inline')
    end
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
  end

end
