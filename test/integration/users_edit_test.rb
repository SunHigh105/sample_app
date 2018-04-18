require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params:{user: {name: "", email: "foo@invalid", password: "foo" ,password_confirmation: "bar"}}
    assert_template 'users/edit'
    assert_select 'div.alert.alert-danger', 'The form contains 3 errors.'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "FooBar"
    email = "foo@bar.com"
    patch user_path(@user), params:{user: {name: name, email: email, password: "" ,password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "successful edit with frendly forwarding" do
    get edit_user_path(@user)
    assert_not session[:forwarding_url].nil?
    log_in_as(@user)    
    assert_redirected_to edit_user_url(@user)
    name = "FooBar"
    email = "foo@bar.com"
    patch user_path(@user), params:{user:{name: name, email: email, password: "",password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    assert session[:forwarding_url].nil?
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
