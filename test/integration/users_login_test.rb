require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "間違ったemailとパスによるログイン" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "有効な情報でのログイン、ログアウト" do
    get login_path
    post login_path, session: {email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    #2番めのウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "ログインしたままにチェックを入れるログイン" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end
  
  test "ログインしたままにチェックを入れないログイン" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_me']
  end
end
