class CampaignController < ApplicationController
  def webhook
    data = JSON.parse(request.body.read)
    
    results = data['Events'].map do |event|
      if user = User.by_email(event['EmailAddress']).first
        user.notifications ||= []
        if event['Type'] == 'Deactivate'
          user.notifications['campaign'] = "0"
          user.save
        end
      end
    end
    
    render nothing: true, status: :success
  end
end