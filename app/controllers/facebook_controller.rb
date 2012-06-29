class FacebookController < ApplicationController

  caches_page :channel
  layout false

  def channel
    expires_in 1.year, public: true
  end

end
