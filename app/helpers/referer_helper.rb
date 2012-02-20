require 'uri'

module RefererHelper

  def referer
    URI.parse(request.referer).host.sub(/^www\./,'') if request.referer
  end

end
