require 'spec_helper'

describe CampaignController do
  describe '#webhook' do
    context 'user unsubscribed' do
      let(:user) { Fabricate :user }
      
      before do
        post_json :webhook, {
          "Events" => [{
            "EmailAddress" => user.email,
            "Type" => "Deactivate",
          }],
          "ListID" => "96c0bbdaa54760c8d9e62a2b7ffa2e13"
        }
      end
      
      it "should update user's notification setting" do
        user.reload
        user.notify?(:campaign).should be_false
      end
      
    end
  end
end