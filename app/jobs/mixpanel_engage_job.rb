class MixpanelEngageJob < Job

  def initialize(distinct_id, options)
    @distinct_id, @options = event, options
  end

  def perform?
    Rails.env.production? or Rails.env.development? or Rails.env.staging?
  end

  def perform!
    Mixpanel.engage(@distinct_id, @options)
  end

end
