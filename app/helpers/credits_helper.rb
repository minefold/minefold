module CreditsHelper

  def format_credits(credits, opts={})
    content_tag(:div, number_with_delimiter(credits), {class: 'cr'}.merge(opts))
  end

end
