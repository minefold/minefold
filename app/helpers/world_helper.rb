module WorldHelper
  def sorted_memberships world
    world.memberships.sort_by do |m|
      (world.players.include?(m.user) ? '0' : '1') + m.user.username.downcase
    end
  end
  
  def link_to_world name, world
    link_to name, [world.creator, world]
  end
  
  def world_path world
    user_world_path world.creator, world
  end

  def edit_world_path world
    edit_user_world_path world.creator, world
  end

  def play_world_path world
    play_user_world_path world.creator, world
  end

end
