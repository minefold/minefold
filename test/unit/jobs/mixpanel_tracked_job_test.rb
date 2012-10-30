require 'test_helper'

class MixpanelTrackedJobTest < ActiveSupport::TestCase

  test "#perform!" do
    mock(Mixpanel).track('event', {property: 5}) { true }
    job = MixpanelTrackedJob.new('event', {property: 5})
    job.perform!
  end
  
end
