require 'test_helper'

class WorldMappedJobTest < ActiveSupport::TestCase

  test "#perform!" do
    server = Server.make!(:played)
    data = {
      'markers' => [{type: 'spawn'}]
    }

    job = WorldMappedJob.new(server.id, 10.minutes.ago.to_i, data)
    job.perform!

    # assert !server.world.map?, "world is already mapped"

    server.reload
    server.world.reload

    assert server.world.map?, "world isn't mapped"
    assert_not_nil server.world.map_data
  end

end
