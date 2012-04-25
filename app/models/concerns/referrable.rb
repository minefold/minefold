module Referrable
  extend ActiveSupport::Concern

  INVITE_TOKEN_LENGTH = 6

  included do
    field :invite_token, type: String, default: ->{
      self.class.free_invite_token
    }
    validates_uniqueness_of :invite_token

    belongs_to :referrer, class_name: 'User', inverse_of: :referrals
    has_many :referrals, class_name: 'User', inverse_of: :referrer

    def referrer=(user)
      write_attribute :referrer_id, user.id unless user.nil? or self == user
    end
  end

  module ClassMethods
    def invite_token_exists?(token)
      where(invite_token: token).exists?
    end

    def free_invite_token
      begin
        token = rand(36 ** INVITE_TOKEN_LENGTH).to_s(36)
      end while invite_token_exists?(token)
      token
    end
  end
end