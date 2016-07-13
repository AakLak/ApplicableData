require 'test_helper'

class NavControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  test "should get features" do
    get :features
    assert_response :success
  end

  test "should get pricing" do
    get :pricing
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

end
