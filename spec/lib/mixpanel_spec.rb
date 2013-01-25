require 'webmock/rspec'
require './lib/mixpanel'

describe Mixpanel do

  subject { described_class.new('token') }

  it "defaults the token to the MIXPANEL env var" do
    ENV['MIXPANEL'] = 'new default token'
    expect(described_class.new.token).to eq('new default token')
  end

  it "isn't #enabled? if the token isn't set" do
    subject.stub(token: nil)
    expect(subject).to_not be_enabled
  end

  it "#track posts events" do
    subject.should_receive(:post).with('/track', {
      event: 'paid',
      properties: {amount: 500, token: 'token', distinct_id: 'abc'}
    })
    subject.track('abc', 'paid', amount: 500)
  end

  it "#track! raises errors" do
    subject.stub(track: false)
    expect {
      subject.track!('abc', 'paid', amount: 500)
    }.to raise_error(Mixpanel::ApiError)
  end

  it "#engage posts engagement metrics" do
    subject.should_receive(:post).with('/engage', {
      '$distinct_id' => '123',
      '$token' => 'token',
      '$add' => { 'cents spent' => 500 }
    })
    subject.engage('123', '$add' => { 'cents spent' => 500 })
  end

  [:set, :add, :append].each do |method|

    it "##{method}_engagement #{method}s a metric" do
      subject.should_receive(:engage).with('123', {
        "$#{method}" => { 'spent' => 123 }
      })
      subject.send("#{method}_engagement", '123', 'spent' => 123)
    end

  end

  describe "#post" do

    it "sends events to api.mixpanel.com" do
      subject.stub(:encode_payload).with(foo: 'bar').and_return('abc123')
      stub_request(:post, 'http://api.mixpanel.com/test').
        with(body: 'data=abc123')
      subject.post('/test', foo: 'bar')
    end

    it "returns true if the response code is 200 and body 1" do
      stub_request(:post, 'http://api.mixpanel.com/test')
        .to_return(status: 200, body: '1')
      expect(subject.post('/test', {})).to be_true
    end

    it "returns false even if the body isn't 1" do
      stub_request(:post, 'http://api.mixpanel.com/test')
        .to_return(status: 200, body: '0')
      expect(subject.post('/test', {})).to be_false
    end

    it "short circuits if the token isn't set" do
      subject.stub(:enabled? => false)
      expect(subject.post('/test', {})).to be_nil
    end

  end

  describe "#encode_payload" do

    it "jsonifies and bas64 encodes data" do
      JSON.should_receive(:generate)
        .with('payload')
        .and_return(:json_string)
      Base64.should_receive(:strict_encode64)
        .with(:json_string)
        .and_return('abc123')
      expect(subject.encode_payload('payload')).to eq('abc123')
    end

  end

end
