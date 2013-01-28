require './app/jobs/mixpanel_track_job'

describe MixpanelTrackJob do

  subject { described_class.new('1234', 'paid', {amount: 5}) }

  it "#perform" do
    # subject.mixpanel.stub(:enabled? => false)
    subject.mixpanel.should_receive(:track!)
      .with('1234', 'paid', {amount: 5})
    subject.perform
  end

end
