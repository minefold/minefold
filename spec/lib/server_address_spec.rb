require './lib/server_address'

describe ServerAddress do

  let(:game) { stub(:static_addresses? => false) }
  let(:server) { stub(
    id: 1,
    funpack_id: 1,
    :cname? => false,
    :static_addresses? => false
  )}

  subject { described_class.new(server) }

  describe "#to_s" do

    it "is the static address if the game is routable" do
      server.stub(:static_addresses? => true)
      expect(subject.to_s).to eq("1.fun-1.us-east-1.foldserver.com")
    end

    it "is the IP if the game isn't routable" do
      server.stub(host: '1.1.1.1', port: 1234)
      expect(subject.to_s).to eq("1.1.1.1:1234")
    end

  end

  describe "#ip" do

    it "is the host and port" do
      server.stub(host: '1.1.1.1', port: 1234)
      expect(subject.ip).to eq('1.1.1.1:1234')
    end

    it "doesn't show the port if it's nil" do
      server.stub(host: '1.1.1.1', port: nil)
      expect(subject.ip).to eq('1.1.1.1')
    end

  end

  describe "#address" do

    it "returns the custom name if available" do
      server.stub(:cname? => true, cname: 'mc.chrislloyd.com.au')
      expect(subject.address).to eq('mc.chrislloyd.com.au')
    end

    it "returns the dynamic address if the custom address is legacy" do
      server.stub(:cname? => true, cname: '1234.foldserver.com')
      expect(subject.address).to eq('1.fun-1.us-east-1.foldserver.com')
    end

    it "provides the default address" do
      expect(subject.address).to eq("1.fun-1.us-east-1.foldserver.com")
    end

  end

end
