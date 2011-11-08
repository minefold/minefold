require 'spec_helper'

feature "Static pages" do
  context 'not signed in' do
    [#'/plans',  # TODO doesnt work signed out
     '/features',
     #'/about',  # Relies on User.dave and User.chris
     '/jobs',
     '/contact',
     '/help',
     '/privacy',
     '/terms',
     '/signup'].each do |url|
        it { visit url }
    end
  end
    
  # context 'signed in' do
  #   let(:user) { create :user }
  #   
  #   before :all do
  #     Capybara.current_driver = :selenium
  #     visit '/login'
  #     fill_in 'Email or username', :with => user.username
  #     fill_in 'Password', :with => 'carlsmum'
  #     click_link 'Login'
  #     current_path.should == '/'
  #   end
  #   
  #   ['/plans',
  #    '/features',
  #    '/about',
  #    '/jobs',
  #    '/contact',
  #    '/help',
  #    '/privacy',
  #    '/terms'].each do |url|
  #      it { visit url }
  #   end
  # end
end