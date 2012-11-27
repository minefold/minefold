module BootstrapFormHelpers
  include TextHelper

  def control_group(*fields, &blk)
    group_class = ['control-group']

    obj = object or (parent_builder and parent_builder.object)

    if obj and obj.respond_to?(:errors) and obj.errors.any? and fields.any? {|field| obj.errors[field].any? }
      group_class << 'error'
    end

    @template.content_tag(:div, class: group_class, &blk)
  end

private

  def errors_for_field(field)
    self.object.errors[field] || []
  end

end
