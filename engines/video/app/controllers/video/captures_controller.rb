require_dependency "video/application_controller"

module Video
  class CapturesController < ApplicationController
    # Same permission model as for stream
    authorize_actions_for Stream
    before_action :set_capture, only: [:show, :destroy]

    # GET /captures/1
    def show
      @clips = @capture.clips.limit(8)
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
