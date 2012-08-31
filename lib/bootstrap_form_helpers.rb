module BootstrapFormHelpers
  include TextHelper

  def control_group(*fields, &blk)
    group_class = ['control-group']

    if object.errors.any? and fields.any? {|field| self.object.errors[field].any? }
      group_class << 'error'
    end

    @template.content_tag(:div, class: group_class, &blk)
  end

private

  def errors_for_field(field)
    self.object.errors[field] || []
  end

end
