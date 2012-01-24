<<<<<<< HEAD
attributes :id, :created_at, :updated_at, :last_mapped_at, :map_assets_url, :map_data
=======
attributes :id, :created_at, :updated_at, :map_assets_url, :last_mapped_at
>>>>>>> Expires brower caching on map assets.

node(:url) {|world| user_world_path(world.creator, world) }

child(world.creator => :creator) {
  extends 'users/_base'
}

child(world.members => :members) {
  extends 'users/_base'
  node(:op, if: ->(u){ world.ops.include?(u)}) { true }
}
