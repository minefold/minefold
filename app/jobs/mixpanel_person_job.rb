class MixpanelPersonJob < Job

  def initialize(distinct_id, options)
    @distinct_id, @options = distinct_id, options
  end

  def perform!
    Mixpanel.person(@distinct_id, @options)
  end

end
