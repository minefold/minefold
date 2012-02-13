object @obj
attributes :title
node(:author_name) {|photo| photo.creator.username }
node(:author_url) {|photo| user_url(photo.creator) }

node(:thumbnail_url) {|photo| photo.file.thumb.url }
node(:thumbnail_width) {|photo| photo.thumb_width }
node(:thumbnail_height) {|photo| photo.thumb_height }

node(:url) {|photo| photo.file.full.url }
node(:width) {|photo| photo.width }
node(:height) {|photo| photo.height }
