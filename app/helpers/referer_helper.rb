require 'uri'

module RefererHelper

  def referer
    URI.parse(request.referer).host if request.referer
  end

end
