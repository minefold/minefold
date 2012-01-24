attributes :id, :created_at, :updated_at, :last_mapped_at, :map_assets_url, :map_data

node(:url) {|world| user_world_path(world.creator, world) }

child(world.creator => :creator) {
  extends 'users/_base'
}

child(world.members => :members) {
  extends 'users/_base'
  node(:op, if: ->(u){ world.ops.include?(u)}) { true }
}
