require 'test_helper'

class MixpanelEngagedJobTest < ActiveSupport::TestCase

  test "#perform!" do
    mock(Mixpanel).engage('id', {'$add' => {property: 5}}) { true }
    job = MixpanelEngagedJob.new('id', {'$add' => {property: 5}})
    job.perform!
  end
  
end
