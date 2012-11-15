require 'test_helper'

class MixpanelEngagedJobTest < ActiveSupport::TestCase

  test "#perform!" do
    mock(Mixpanel).person('id', {'$add' => {property: 5}}) { true }
    job = MixpanelPersonJob.new('id', {'$add' => {property: 5}})
    job.perform!
  end

end
