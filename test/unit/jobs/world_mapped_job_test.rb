require 'test_helper'

class WorldMappedJobTest < ActiveSupport::TestCase

  test "#perform!" do
    world = World.make!(:played)
    data = {
      'markers' => [{type: 'spawn'}]
    }

    job = WorldMappedJob.new(world.party_cloud_id, 10.minutes.ago.to_i, data)
    job.perform!

    assert !world.map?, "world is already mapped"

    world.reload

    assert world.map?, "world isn't mapped"
    assert_not_nil world.map_data
  end

end
