require 'test_helper'

class OpenGraphHelperTest < ActionView::TestCase

  test "#app_open_graph_property" do
    ENV['FACEBOOK_APP_NS'] = 'testns'
    assert_equal 'testns:prop', app_open_graph_property(:prop)
  end

end
