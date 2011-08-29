require 'spec_helper'

describe Order do

  it { should be_timestamped_document}
  it { should be_paranoid_document}

  it { should belong_to(:user)}
  it { should embed_many(:transactions)}

  it "#fulfill! gives the user credits" do
    User.any_instance.should_receive(:increment_credits!).with(24.hours)

    order = Order.new
    order.user = User.new
    order.fulfill!(24)
  end

  it '#status reports the last status' do
    order = Order.new
    order.status.should == :pending

    order.transactions.build(payment_status: 'Completed')

    order.status.should == :completed
  end

  it '#gross calculates the actual gross of the order' do
    order = Order.new
    [1,2,3, -4].each do |x|
      order.transactions.build(payment_gross: x)
    end

    order.gross.should == (1 + 2 + 3 - 4)
  end

  it '#fee calculates the processing fee of the order' do
    order = Order.new
    [1,2,3, -4].each do |x|
      order.transactions.build(payment_fee: x)
    end

    order.fee.should == (1 + 2 + 3 - 4)
  end

end
