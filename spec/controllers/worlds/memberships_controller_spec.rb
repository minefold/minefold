require 'spec_helper'

describe Worlds::MembershipsController do
  render_views

  let(:creator) { Fabricate(:user) }
  let(:world)   { Fabricate(:world) }

  let(:user) { Fabricate(:user) }

  context 'signed in' do
    signin_as { world.creator }
  end

end
