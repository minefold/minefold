require 'spec_helper'

describe Funpack do
  let(:plan) { Plan.make! }
  subject { Funpack.make!(bolt_allocations: [512, 1024, 2048]) }

  its(:bolt_allocations) { should == [512, 1024, 2048] }

  context 'plan allocations' do
    before { subject.plan_allocations.create(ram: 512, players: 15)}
    let(:allocation) { subject.reload.plan_allocations.first }

    it { allocation.ram.should == 512 }
    it { allocation.players.should == 15 }
  end
end
