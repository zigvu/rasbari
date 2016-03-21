require 'test_helper'

module Kheer
  class CaptureEvaluationsControllerTest < ActionController::TestCase
    setup do
      @capture_evaluation = kheer_capture_evaluations(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:capture_evaluations)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create capture_evaluation" do
      assert_difference('CaptureEvaluation.count') do
        post :create, capture_evaluation: { capture_id: @capture_evaluation.capture_id, chia_model_id: @capture_evaluation.chia_model_id, gpu_machine_id: @capture_evaluation.gpu_machine_id, user_id: @capture_evaluation.user_id, zstate: @capture_evaluation.zstate }
      end

      assert_redirected_to capture_evaluation_path(assigns(:capture_evaluation))
    end

    test "should show capture_evaluation" do
      get :show, id: @capture_evaluation
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @capture_evaluation
      assert_response :success
    end

    test "should update capture_evaluation" do
      patch :update, id: @capture_evaluation, capture_evaluation: { capture_id: @capture_evaluation.capture_id, chia_model_id: @capture_evaluation.chia_model_id, gpu_machine_id: @capture_evaluation.gpu_machine_id, user_id: @capture_evaluation.user_id, zstate: @capture_evaluation.zstate }
      assert_redirected_to capture_evaluation_path(assigns(:capture_evaluation))
    end

    test "should destroy capture_evaluation" do
      assert_difference('CaptureEvaluation.count', -1) do
        delete :destroy, id: @capture_evaluation
      end

      assert_redirected_to capture_evaluations_path
    end
  end
end
