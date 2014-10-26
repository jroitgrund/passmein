require 'test_helper'

class DetailsControllerTest < ActionController::TestCase
  setup do
    @user = users(:foobar)
    @one = details(:one)
  end

  #### INDEX ####
  test "index returns 401 if logged out" do
    get :index
    assert_response :unauthorized
  end

  test "index returns user's details if logged in" do
    get :index, {}, user_id: @user.id
    assert_response :ok
    assert_equal(@user.details.to_json, @response.body)
  end


  #### CREATE ####
  test "create returns 401 if logged out" do
    post :create, {site: 'foo', data: 'bar'}
    assert_response :unauthorized
  end

  test "create returns 400 if missing fields" do
    post :create, {site: 'foo'}, user_id: @user.id
    assert_response :bad_request
  end

  test "create creates new details with sane input" do
    assert_difference('@user.details.count', 1) do
      post :create, {site: 'foo', data: 'bar'}, user_id: @user.id
    end
    assert_response :created
  end


  #### UPDATE ####
  test "update returns 401 if logged out" do
    patch :update, {id: @one.id, site: 'fooo'}
    assert_response :unauthorized
  end

  test "update returns 400 if inexistent id" do
    patch :update, {id: 5654214541, site: 'fooo'}, user_id: @user.id
    assert_response :bad_request
  end

  test "update updates details with sane input" do
    new_site = 'fooo'
    patch :update, {id: @one.id, site: new_site}, user_id: @user.id
    assert_response :ok
    assert_equal(new_site, Detail.find(@one.id).site)
  end


  #### DESTROY ####
  test "destroy returns 401 if logged out" do
    delete :destroy, {id: @one.id}
    assert_response :unauthorized
  end

  test "destroy returns 400 if inexistent id" do
    assert_no_difference('@user.details.count') do
      delete :destroy, {id: 554151431}, user_id: @user.id
    end
    assert_response :bad_request
  end

  test "destroy destroys details with sane input" do
    assert_difference('@user.details.count', -1) do
      delete :destroy, {id: @one.id}, user_id: @user.id
    end
    assert_response :ok
  end
end