require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  %w(home about help pricing jobs privacy terms).each do |page|
    test "GET ##{page}" do
      get page
      assert_response :success
    end
  end

end
