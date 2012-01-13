require 'spec_helper'

describe Worlds::MembershipsController do
  render_views

  let(:creator) { create :user }
  let(:world)   { create :world, creator: creator }

  let(:user) { create :user }

  context 'signed in' do
    signin_as { creator }
  end

end
