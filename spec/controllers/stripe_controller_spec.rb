require 'spec_helper'

describe StripeController do
  let(:user) do
    build(:user).tap {|u| set_plan u, Plan.large }
  end
  
  describe '#webhook' do
    context 'recurring_payment_succeeded' do
      it "should renew plan on user" do
        user.save!

        user.credits = 200
        user.save!
          
        post :webhook, customer: 'cus_1', event: 'recurring_payment_succeeded',
                                        invoice: {
                                          lines: {
                                            subscriptions: [{
                                              plan: {
                                                id: "medium"
                                              }
                                            }]
                                          }
                                        }
        
        user.reload.credits.should be > 200
      end
    end
    
    context 'recurring_payment_failed' do
      before do
        user.save!
        post :webhook, customer: 'cus_1', 
                          event: 'recurring_payment_failed',
                        attempt: 1,
                        payment: {
                            time: 1297887533,
                            card: {
                              type: "Visa",
                              last4: "4242"
                            },
                            success: false
                          }
      end
      
      it "should set flag on user" do
        user.reload.failed_payment_attempts.should == 1
      end
    end
  end
end