require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "ユーザー登録失敗" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: "",
                              email: "user@invalid",
                              password:"foo",
                              password_confirmation:"bar"}
    end
    assert_template 'users/new'
  end
  
  test "ユーザー登録成功" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: "Example User",
        email: "user@ex.com",
        password: "password",
        password_confirmation: "password" }
    end
    assert_template 'users/show'
    assert is_logged_in?
  end
end
