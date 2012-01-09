module WorldHelper
  def sorted_memberships world
    world.memberships.sort_by do |m|
      (world.players.include?(m.user) ? '0' : '1') + m.user.username.downcase
    end
  end

end
