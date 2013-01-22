require './app/jobs/mixpanel_track_job'

describe MixpanelTrackJob do

  subject { described_class.new('paid', {amount: 5}) }

  it "#perform" do
    subject.mixpanel.should_receive(:track)
      .with('paid', {amount: 5})
    subject.perform
  end

end
