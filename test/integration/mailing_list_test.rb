require 'test_helper'

class MailingListTest < ActionDispatch::IntegrationTest

  test "form exists" do
    get root_path

    assert_select 'form', action: 'http://minefold.createsend.com/t/r/s/qjhfu'
    assert_select 'form input', name: 'cm-qjhfu-qjhfu'
    assert_select 'button'
  end

end
