class Invite
  # include Mongoid::Document
  # include Mongoid::Timestamps
  #
  # embedded_in :user
  #
  # field :claimed_at, type: DateTime
  # field :facebook_uid
  #
  # validates_uniqueness_of :facebook_uid, scope: :user_id
  # validates_presence_of :facebook_uid
  #
  # def claim!
  #   self.claimed_at = Time.now
  #   save!
  # end
  #
  # def claimed?
  #   !!claimed_at
  # end
end
