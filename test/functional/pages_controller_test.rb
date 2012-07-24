require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  %w(home about freetime help pricing jobs privacy terms).each do |page|
    test "get #{page}" do
      get page
      assert_response :success
    end
  end

end
