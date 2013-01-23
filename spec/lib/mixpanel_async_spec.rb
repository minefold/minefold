require './lib/mixpanel_async'

describe MixpanelAsync do

  subject {
    described_class.enable!
    described_class
  }

  it "#track enqueues track jobs" do
    Resque.should_receive(:enqueue)
      .with(MixpanelTrackJob, 'paid', { amount: 500 })
    subject.track('paid', amount: 500)
  end

  it "#engage enqueues engagement jobs" do
    Resque.should_receive(:enqueue)
      .with(MixpanelEngageJob, '123', { '$add' => { amount: 500 }})
    subject.engage('123', { '$add' => { amount: 500 }})
  end

  it "doesn't #enqueue jobs if it's not explicitely enabled" do
    subject.stub(:enabled? => false)
    Resque.should_not_receive(:enqueue)
    subject.enqueue(Object, :argument)
  end

end
