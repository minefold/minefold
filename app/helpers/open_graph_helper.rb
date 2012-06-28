module OpenGraphHelper

  def app_open_graph_property(name)
    [ENV['FACEBOOK_APP_NS'], name].join(':')
  end

  def open_graph_tags(hash)
    tags = hash.map do |property, content|
      tag(:meta, property: property, content: content)
    end

    tags << tag(:meta, property: 'og:site_name', content: 'Choose Fun')

    tags.join("\n").html_safe
  end

  def open_graph_tags_for(obj, attrs)
    open_graph_tags({
      'og:type' => obj.class.open_graph_type,
      'og:title' => obj.open_graph_title,
      'og:description' => obj.open_graph_description,
      'og:image' => obj.open_graph_image,
      'og:updated_time' => obj.updated_at.to_i,
    }.merge(attrs))
  end

end
