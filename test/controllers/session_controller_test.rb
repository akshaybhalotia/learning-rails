require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  test "should get login" do
    get :new
    assert_response :success
  end

  test "should login" do
    akshay = users(:one)
    post :create, name: akshay.name, password: 'secret'
    assert_redirected_to admin_url
    assert_equal akshay.id, session[:user_id]
  end

  test "should fail login" do
    session[:user_id] = nil
    akshay = users(:one)
    post :create, name: akshay.name, password: 'xyz'
    assert_redirected_to login_url
    assert_not_equal akshay.id, session[:user_id]
  end

  test "should get destroy" do
    get :destroy
    assert_redirected_to store_url
    assert_nil session[:user_id]
  end

end
