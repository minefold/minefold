module Concerns::Activity::Subject
  extend ActiveSupport::Concern

  included do
    has_many :activities, :as => :subject
    has_many :private_activities, :as => :target
  end

end
