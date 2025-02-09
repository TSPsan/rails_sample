require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user  = users(:michael)
    @guest =users(:guest)
  end

	test "login with invalid information" do
			get login_path
			assert_template 'sessions/new'
			post login_path, params: { session: { email: "", password: "" } }
			assert_template 'sessions/new'
			assert_not flash.empty?
			get root_path
			assert flash.empty?
	end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,           count: 0
    assert_select "a[href=?]", users_path,            count: 0
    assert_select "a[href=?]", user_path(@user),      count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

  # ゲストユーザーとしてログイン
  test "login as guest" do
    # ゲストユーザーとしてSessionsコントローラアクションでログイン
    get guest_login_path
    # ゲストユーザーとしてログインしたらHomeに行く
    assert_redirected_to root_url
    assert is_logged_in?
    assert_not flash.empty?
  end
end
