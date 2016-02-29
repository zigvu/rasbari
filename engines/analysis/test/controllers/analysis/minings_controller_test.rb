require 'test_helper'

module Analysis
  class MiningsControllerTest < ActionController::TestCase
    setup do
      @mining = analysis_minings(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:minings)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create mining" do
      assert_difference('Mining.count') do
        post :create, mining: { chia_model_id_anno: @mining.chia_model_id_anno, chia_model_id_loc: @mining.chia_model_id_loc, description: @mining.description, name: @mining.name, user_id: @mining.user_id, zstate: @mining.zstate, ztype: @mining.ztype }
      end

      assert_redirected_to mining_path(assigns(:mining))
    end

    test "should show mining" do
      get :show, id: @mining
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @mining
      assert_response :success
    end

    test "should update mining" do
      patch :update, id: @mining, mining: { chia_model_id_anno: @mining.chia_model_id_anno, chia_model_id_loc: @mining.chia_model_id_loc, description: @mining.description, name: @mining.name, user_id: @mining.user_id, zstate: @mining.zstate, ztype: @mining.ztype }
      assert_redirected_to mining_path(assigns(:mining))
    end

    test "should destroy mining" do
      assert_difference('Mining.count', -1) do
        delete :destroy, id: @mining
      end

      assert_redirected_to minings_path
    end
  end
end
