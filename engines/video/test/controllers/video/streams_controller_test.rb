require 'test_helper'

module Video
  class StreamsControllerTest < ActionController::TestCase
    setup do
      @stream = video_streams(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:streams)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create stream" do
      assert_difference('Stream.count') do
        post :create, stream: { machine_id: @stream.machine_id, name: @stream.name, zstate: @stream.zstate, ztype: @stream.ztype, url: @stream.url }
      end

      assert_redirected_to stream_path(assigns(:stream))
    end

    test "should show stream" do
      get :show, id: @stream
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @stream
      assert_response :success
    end

    test "should update stream" do
      patch :update, id: @stream, stream: { machine_id: @stream.machine_id, name: @stream.name, zstate: @stream.zstate, ztype: @stream.ztype, url: @stream.url }
      assert_redirected_to stream_path(assigns(:stream))
    end

    test "should destroy stream" do
      assert_difference('Stream.count', -1) do
        delete :destroy, id: @stream
      end

      assert_redirected_to streams_path
    end
  end
end
