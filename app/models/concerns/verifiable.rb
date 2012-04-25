module Verifiable
  extend ActiveSupport::Concern

  VERIFICATION_TOKEN_LENGTH = 6

  included do
    field :verification_token, type: String, default: ->{
      self.class.free_verification_token
    }
    validates_uniqueness_of :verification_token
  end

  module ClassMethods
    def verification_token_exists?(token)
      where(verification_token: token).exists?
    end

    def free_verification_token
      begin
        token = rand(36 ** VERIFICATION_TOKEN_LENGTH).to_s(36)
      end while verification_token_exists?(token)
      token
    end
  end
end