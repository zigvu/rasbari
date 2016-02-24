require 'test_helper'

module Kheer
  class ChiaModelsControllerTest < ActionController::TestCase
    setup do
      @chia_model = kheer_chia_models(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:chia_models)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create chia_model" do
      assert_difference('ChiaModel.count') do
        post :create, chia_model: { comment: @chia_model.comment, description: @chia_model.description, detectable_ids: @chia_model.detectable_ids, major_id: @chia_model.major_id, minor_id: @chia_model.minor_id, name: @chia_model.name }
      end

      assert_redirected_to chia_model_path(assigns(:chia_model))
    end

    test "should show chia_model" do
      get :show, id: @chia_model
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @chia_model
      assert_response :success
    end

    test "should update chia_model" do
      patch :update, id: @chia_model, chia_model: { comment: @chia_model.comment, description: @chia_model.description, detectable_ids: @chia_model.detectable_ids, major_id: @chia_model.major_id, minor_id: @chia_model.minor_id, name: @chia_model.name }
      assert_redirected_to chia_model_path(assigns(:chia_model))
    end

    test "should destroy chia_model" do
      assert_difference('ChiaModel.count', -1) do
        delete :destroy, id: @chia_model
      end

      assert_redirected_to chia_models_path
    end
  end
end
