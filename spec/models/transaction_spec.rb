# require 'spec_helper'
#
# describe Transaction do
#
#   it { should be_timestamped_document }
#
#   it { should be_embedded_in(:order) }
#
#   Transaction::PAYMENT_STATUSES.each do |status|
#     it "is #{status.downcase} when the payment_status is '#{status}'" do
#       transaction = Transaction.new(payment_status: status)
#       transaction.send("#{status.downcase}?").should be_true
#     end
#   end
#
#   it "#status should be :pending by default" do
#     Transaction.new.status.should == :pending
#   end
#
#   it "#status should be reflect the payment_status" do
#     transaction = Transaction.new(payment_status: 'Completed')
#     transaction.should be_completed
#     transaction.status.should == :completed
#   end
#
#
#   it "#hours returns the ActiveSupport hours format" do
#     transaction = Transaction.new(option_selection1: 48)
#     transaction.hours.should == 48.hours
#   end
#
#   it "#credits returns the hours in credits" do
#     transaction = Transaction.new(option_selection1: 48)
#     transaction.credits.should == (48.hours / User::BILLING_PERIOD)
#   end
#
#   it "#gross is a float" do
#     transaction = Transaction.new(payment_gross: '9.95')
#     transaction.gross.should be_a(Float)
#     transaction.gross.should == 9.95
#   end
#
#   it "#fee is a float" do
#     transaction = Transaction.new(payment_fee: '0.95')
#     transaction.fee.should be_a(Float)
#     transaction.fee.should == 0.95
#   end
#
#   it "#total should be the gross less any fees" do
#     transaction = Transaction.new(payment_gross: '64.00',
#                                   payment_fee: '22.00')
#     transaction.total.should == 42.00
#   end
#
# end
