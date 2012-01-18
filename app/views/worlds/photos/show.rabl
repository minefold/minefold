object photo
node(:url) {|photo| world_photo_path(world, photo)}

attributes :id, :created_at, :updated_at, :title, :caption

node(:src) {|photo| photo.file.url }

child(photo.creator => :creator) {
  extends 'users/base'
}
