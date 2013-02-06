class Webhooks::PartyCloudController < ApplicationController

  protect_from_forgery :except => :hook

  def hook
    event = JSON.parse(request.body.read, symbolize_names: true)
    type, data = event[:type], event[:data]

    case type
    when 'funpack.updated'
      funpack_updated(event, data)
    end
  end

  def funpack_updated(event, data)
    funpack = Funpack.find_by_party_cloud_id(data[:id])
    funpack.settings_schema = data[:object][:schema]
    funpack.save!

    render nothing: true, status: 200
  end

end
