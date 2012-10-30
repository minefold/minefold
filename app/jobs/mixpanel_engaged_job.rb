class MixpanelEngagedJob < Job

  def initialize(distinct_id, options)
    @distinct_id, @options = distinct_id, options
  end

  def perform!
    Mixpanel.engage(@distinct_id, @options)
  end

end
