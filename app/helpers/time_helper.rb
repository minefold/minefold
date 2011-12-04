module TimeHelper

  def time_ago_in_words(time, options={}, &blk)
    options[:class] ||= 'timeago'
    content_tag(:time, time.to_s, options.merge(datetime: time.getutc.iso8601))
  end

end
