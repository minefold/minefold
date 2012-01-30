require 'spec_helper'

describe AccountsController do
  context 'signed in' do
    signin_as { Fabricate(:user) }
  
    describe '#update' do
      context 'changing a notification setting' do
        before { 
          put :update, user: { notifications: { world_started: false } }  
        }
        
        subject { current_user.reload }
        
        its(:notifications) { should == { 'world_started' => false } }
      end
    end
  end
end