# Handles anything to do with forrectly formatting

module CreditsHelper
  
  def format_credits(credits)
    number_with_delimiter(credits)
  end

  def credits_with_image(credits, opts={})
    content_tag(:span, format_credits(credits), {class: 'cr'}.merge(opts))
  end
  
end
