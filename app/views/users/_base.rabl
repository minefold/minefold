attribute :id, :created_at
attributes :safe_username => :username,
           :avatar_url => :avatar

node(:url) {|user| user_path(user) }
