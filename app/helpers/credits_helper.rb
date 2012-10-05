# Handles anything to do with forrectly formatting

module CreditsHelper
  
  def link_to_buy_credits
    content_tag :a, 'Buy credits',
      href: new_orders_path,
      data: { toggle: 'modal', target: '#buy-credits-modal' }
  end
  
  def format_credits(credits)
    number_with_delimiter(credits)
  end

  def credits_with_image(credits, opts={})
    content_tag(:span, format_credits(credits), {class: 'cr'}.merge(opts))
  end
  
end
