require_dependency "video/application_controller"

module Video
  class CapturesController < ApplicationController
    # Same permission model as for stream
    authorize_actions_for Stream
    authority_actions :start_vnc => :read
    authority_actions :force_stop => :read

    before_action :set_capture, only: [:show, :destroy, :start_vnc, :force_stop]

    # GET /captures/1/start_vnc
    def start_vnc
      status, trace = Video::CaptureWorkflow::StartVncServer.new(@capture).handle({})
      notice = status ? :notice : :alert
      redirect_to capture_path(@capture), notice => trace
    end

    # GET /captures/1/force_stop
    def force_stop
      status, trace = Video::CaptureWorkflow::StopCapture.new(@capture).handle({
        current_user_id: current_user.id
      })
      notice = status ? :notice : :alert
      redirect_to capture_path(@capture), notice => trace
    end

    # GET /captures/1
    def show
      @clips = @capture.clips.order(id: :desc).limit(8)
    end

    # GET /captures/new
    def new
      stream = Stream.find(params[:stream_id])
      capture = stream.captures.create
      stream.state.setConfiguring
      redirect_to capture_workflow_path(Wicked::FIRST_STEP, capture_id: capture.id)
    end

    # DELETE /captures/1
    def destroy
      # clean up any pending workflow steps
      Video::CaptureWorkflow::StopCapture.new(@capture).handle({
        current_user_id: current_user.id
      })
      @capture.destroy
      redirect_to stream_path(@stream), notice: 'Capture was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_capture
        @capture = Capture.find(params[:id])
        @stream = @capture.stream
      end
  end
end
