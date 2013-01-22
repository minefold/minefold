require './app/jobs/mixpanel_engage_job'

describe MixpanelEngageJob do

  subject { described_class.new('id', '$set' => {time: 5}) }

  it "#perform" do
    subject.mixpanel.should_receive(:engage)
      .with('id', '$set' => {time: 5})
    subject.perform
  end

end
