module WorldHelper

  def world_fullname(world)
    [world.creator.username, world.name].join('/')
  end

  def strong_world_fullname(world)
    [ h(world.creator.username),
      content_tag(:strong, h(world.name))
    ].join('/').html_safe
  end

end
