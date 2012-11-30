module FlipperHelper

  def feature
    $flipper
  end

  def enabled?(feature)
    signed_in? and $flipper[feature].enabled?(current_user)
  end

end
