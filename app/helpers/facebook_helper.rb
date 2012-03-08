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
      tag('meta', property: "og:#{key}", content: value)
    end.join.html_safe
  end

  def world_og_attrs(world)
    attrs = {
      type: 'minefold:world',
      url: user_world_url(world.creator, world),
      title: h(world.name),
      description: h('Minecraft world'),
      image: world.photo.url,
      'minefold:members' => world.members.count
    }

    if world.parent
      attrs['minefold:parent'] = user_world_url(world.parent.creator, world.parent)
    end

    attrs
  end



end
