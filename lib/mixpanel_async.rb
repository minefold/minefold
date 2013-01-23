require 'resque'
require './app/jobs/mixpanel_track_job'
require './app/jobs/mixpanel_engage_job'

class MixpanelAsync

  @enabled = false

  def self.enable!
    @enabled = true
  end

  def self.enabled?
    @enabled
  end

  def self.track(*args)
    enqueue MixpanelTrackJob, *args
  end

  def self.engage(*args)
    enqueue MixpanelEngageJob, *args
  end

# --

  def self.enqueue(klass, *args)
    if enabled?
      Resque.enqueue(klass, *args)
    end
  end

end
