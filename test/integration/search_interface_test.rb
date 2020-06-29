require 'test_helper'

class SearchInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  # 検索機能のフォームがあるか
  test "layout search_form" do
    log_in_as(@user)
    get root_path
    assert_select "div.search_form"
    get users_path
    assert_select "div.search_form"
    get user_path(@user)
    assert_select "div.search_form"
  end

  # 該当するキーワードの投稿のみを検索してくれるか
  test "shuold search when existent_keyword" do
    log_in_as(@user)
    # StaticPages#homeでの検索確認
    get root_path
    get root_path, params: { search: "orange" }
    assert_match "フレンド投稿 (1)", response.body
    # Users#indexでの確認
    get users_path
    get users_path, params: { search: "ゲストユーザー" }
    assert_match "ユーザー (1)", response.body
    # Users#showでの確認
    get user_path(@user)
    get user_path(@user, search: "orange")
    assert_match "投稿 (1)", response.body
  end

  # 該当しないキーワードで検索しても何も表示されないか
  test "shuold not  search when non-existent_keyword " do
    log_in_as(@user)
    # StaticPages#homeでの検索確認
    get root_path
    get root_path, params: { search: "apple" }
    assert_match "フレンド投稿 (0)", response.body
    # Users#indexでの確認
    get users_path
    get users_path, params: { search: "存在しないユーザー" }
    assert_match "ユーザー (0)", response.body
    # Users#showでの確認
    get user_path(@user)
    get user_path(@user, search: "apple")
    assert_match "投稿 (0)", response.body
  end

  # SQLインジェクション対策できているか
  test "sanitize when dengerous_parameter" do
		dangerous_parameter = "' OR '1') --"
    log_in_as(@user)
    # StaticPages#homeでの検索確認
    get root_path
    get root_path,  params: { search: dangerous_parameter }
    assert_match "フレンド投稿 (0)", response.body
    # Users#indexでの確認
    get users_path
    get users_path, params: { search: dangerous_parameter }
    assert_match "ユーザー (0)", response.body
    # Users#showでの確認
    get user_path(@user)
    get user_path(@user, search: dangerous_parameter)
    assert_match "投稿 (0)", response.body
	end
end
