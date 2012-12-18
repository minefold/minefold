require 'spec_helper'

describe ServerSettingsChangedJob do

  let(:server) { Server.make! }

  it "accepts the old Party Cloud style" do
    subject = described_class.new(server.party_cloud_id, {
      'setting' => 'whitelist_add', 'value' => 'chrislloyd'
    })

    expect(subject.key).to eq('whitelist_add')
    expect(subject.value).to eq('chrislloyd')
  end

  it "accepts the new Party Cloud style" do
    subject = described_class.new(server.party_cloud_id, 'whitelist_add', 'chrislloyd')

    expect(subject.key).to eq('whitelist_add')
    expect(subject.value).to eq('chrislloyd')
  end

  # --

  describe "#whitelist_add!" do
    pending
  end

  describe "#whitelist_remove!" do
    pending
  end

  describe "#ops_add!" do
    pending
  end

  describe "#ops_remove!" do
    pending
  end

  describe "#blacklist_add!" do
    pending
  end

  describe "#blacklist_remove!" do
    pending
  end

end
