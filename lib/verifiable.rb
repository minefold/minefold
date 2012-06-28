module Verifiable
  extend ActiveSupport::Concern

  included do
    field :verification_token, type: String
    validates_uniqueness_of :verification_token
  end
end