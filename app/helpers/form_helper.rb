module FormHelper

  def error_class(form, field)
    if errors = errors_for_field(form, field) and errors.any?
      'error'
    end
  end

  def error_message(form, field)
    if errors = errors_for_field(form, field) and errors.any?
      content_tag(:span, errors.to_sentence, class: 'help-inline')
    end
  end

# private

  def errors_for_field(form, field)
    form.object.errors[field]
  end

end
