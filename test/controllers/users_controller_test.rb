require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "ログインしていないときのindexページは、飛ぶはず" do
    get :index
    assert_redirected_to login_url
  end


  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "ログインしてない時にeditすると飛ぶはず" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "ログインしてない時にupdateすると飛ぶはず" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "他のユーザーでログインしているときにeditするとリダイレクトするはず" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "他のユーザーでログインしているときにupdateするとリダイレクトするはず" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "ログインしてない時にdestroyすると飛ぶはず" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
  
  test "非管理者でログインしてる時にdestroyすると飛ぶはず" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
end
