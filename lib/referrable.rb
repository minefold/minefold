module Referrable
  extend ActiveSupport::Concern

  INVITE_TOKEN_LENGTH = 6

  included do
    field :invite_token, type: String
    validates_uniqueness_of :invite_token

    belongs_to :referrer, class_name: 'Referral', inverse_of: :target
    has_many :referrals, class_name: 'Referral', inverse_of: :source
    
    embeds_many :invites
  end
  
  def referrer=(user)
    unless user.nil? or self == user
      write_attribute :referrer_id, user.id
      user.claim_invite!(self)
    end
  end
  
  def referred?
    !!referrer
  end
  
  def claim_invite!(referred_user)
    if invite = invites.where(facebook_uid: referred_user.facebook_uid)
      invite.claim!(referred_user)
    end
  end
end