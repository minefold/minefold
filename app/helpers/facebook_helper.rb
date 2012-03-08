module FacebookHelper

  def fb_head_prefix
    { 'og' => 'http://ogp.me/ns',
      'fb' => 'http://ogp.me/ns/fb',
      'minefold' => 'http://ogp.me/ns/fb/minefold'
    }.map {|t,url| "#{t}: #{url}#" }.join(' ')
  end

  def og_tags(obj)
    case obj.class
    when World
      world_og_attrs(obj)
    else
      []
    end.map do |key, value|
      tag('meta', property: key.to_s, content: value.to_s)
    end.join.html_safe
  end

  def world_og_attrs(world)
    attrs = {
      'og:type' => 'minefold:world',
      'og:url' => user_world_url(world.creator, world),
      'og:title' => h(world.name),
      'og:description' => h('Minecraft world'),
      'og:image' => world.photo.url,
      'minefold:members' => world.members.count
    }

    if world.parent
      attrs['minefold:parent'] = user_world_url(world.parent.creator, world.parent)
    end

    attrs
  end



end
