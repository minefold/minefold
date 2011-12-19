# Removes old collections

%W(invites orders wall_items).each do |col|
  User.db[col].drop
end
