attributes :id, :created_at, :updated_at, :map_assets_url, :desc

node(:url) {|world| world_path(world) }

child(world.creator => :creator) {
  extends 'users/_base'
}

child(world.members => :members) {
  extends 'users/_base'
  node(:op, if: ->(u){ world.ops.include?(u)}) { true }
}
