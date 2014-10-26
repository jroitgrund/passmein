require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:foobar)
    @one = details(:one)
    @three = details(:three)
  end

  #### LOGIN ####
  test "login returns 401 if incorrect credentials" do
    post :login, login: @user.login, old_response: @user.response + 'a', challenge: 'c', response: 'r'
    assert !session[:user_id]
    assert_response :unauthorized
  end

  test "login logs in with correct credentials, and updates challenge response" do
    challenge = 'c'
    response = 'r'
    post :login, login: @user.login, old_response: @user.response, challenge: challenge, response: response
    assert_response :ok
    assert_equal(@user.id, session[:user_id])
    assert_equal(challenge, User.find(@user).challenge)
    assert_equal(response, User.find(@user).response)
  end

  test "login sends challenge if response not in params" do
    post :login, login: @user.login, challenge: 'c', response: 'r'
    assert_equal(@user.challenge, JSON.parse(@response.body)['challenge'])
  end

  test "login creates new user with new login" do
    login = @user.login + 'a'
    assert_difference('User.count', 1) do
      post :login, login: login, challenge: 'c', response: 'r'
    end
    assert_response :created
    assert_equal(User.find_by_login(login).id, session[:user_id])
  end



  #### LOGOUT ####
  test "logout logs out successfully" do
    post :logout, {}, user_id: 5
    assert !session[:user_id]
  end


  #### UPDATE ###
  test "update returns 401 if logged out" do
    patch :update, {password: 'foo', password_confirmation: 'foo'}
    assert_response :unauthorized
  end

  test "update changes the password if logged in and new data validates" do
    patch :update, {challenge: 'c', response: 'r', details:[{id: @one.id, site: 'baz'}]}, user_id: @user.id
    assert_response :ok
    assert_equal('c', User.find(@user).challenge)
    assert_equal('baz', Detail.find(@one).site)
  end

  test "update doesn't change anything if data doesn't validate" do
    patch :update, {challenge: 'c', response: 'r', details:[{id: @three.id, site: 'baz'}]}, user_id: @user.id
    assert_response :bad_request
    assert_equal(@user, User.find(@user))
    assert_equal(@three, Detail.find(@three))
  end
end
