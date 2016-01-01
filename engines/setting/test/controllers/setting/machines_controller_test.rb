require 'test_helper'

module Setting
  class MachinesControllerTest < ActionController::TestCase
    setup do
      @machine = setting_machines(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:machines)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create machine" do
      assert_difference('Machine.count') do
        post :create, machine: { zcloud: @machine.zcloud, hostname: @machine.hostname, ip: @machine.ip, zdetails: @machine.zdetails, zstate: @machine.zstate, ztype: @machine.ztype }
      end

      assert_redirected_to machine_path(assigns(:machine))
    end

    test "should show machine" do
      get :show, id: @machine
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @machine
      assert_response :success
    end

    test "should update machine" do
      patch :update, id: @machine, machine: { zcloud: @machine.zcloud, hostname: @machine.hostname, ip: @machine.ip, zdetails: @machine.zdetails, zstate: @machine.zstate, ztype: @machine.ztype }
      assert_redirected_to machine_path(assigns(:machine))
    end

    test "should destroy machine" do
      assert_difference('Machine.count', -1) do
        delete :destroy, id: @machine
      end

      assert_redirected_to machines_path
    end
  end
end
