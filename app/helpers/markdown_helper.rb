module MarkdownHelper

  Pipeline = HTML::Pipeline.new([
    HTML::Pipeline::MarkdownFilter,
    HTML::Pipeline::SanitizationFilter,
    HTML::Pipeline::EmojiFilter
    ], {
    asset_root: '/images'
  })

  def markdown(text)
    Pipeline.call(text)[:output].to_s.html_safe
  end

end
