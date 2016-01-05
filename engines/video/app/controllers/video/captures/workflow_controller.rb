require_dependency "video/application_controller"

module Video
  class Captures::WorkflowController < ApplicationController
    include Wicked::Wizard
    before_action :set_steps
    before_action :setup_wizard

    before_action :set_steps_ll, only: [:show, :update]

    def show
      case step
      when :set_details
        @workflowObj = Video::CaptureWorkflow::SetDetails.new(@capture)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :set_machines
        @workflowObj = Video::CaptureWorkflow::SetMachines.new(@capture)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :ping_nimki
        @workflowObj = Video::CaptureWorkflow::PingNimki.new(@capture)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :set_remote_ready
        @workflowObj = Video::CaptureWorkflow::SetRemoteReady.new(@capture)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :start_capture
        @workflowObj = Video::CaptureWorkflow::StartCapture.new(@capture)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :stop_capture
        @workflowObj = Video::CaptureWorkflow::StopCapture.new(@capture)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      end

      render_wizard
    end

    def update
      status = false
      message = "Could not complete step - please check for mistakes"

      case step
      when :set_details
        prms = params.require(:capture)
          .permit(:capture_url, :comment, :width, :height, :playback_frame_rate)
        status, message = Video::CaptureWorkflow::SetDetails.new(@capture).handle(prms)
      when :set_machines
        prms = params.require(:capture).permit(:storage_machine_id, :capture_machine_id)
        status, message = Video::CaptureWorkflow::SetMachines.new(@capture).handle(prms)
      when :ping_nimki
        status, message = Video::CaptureWorkflow::PingNimki.new(@capture).handle(params)
      when :set_remote_ready
        status, message = Video::CaptureWorkflow::SetRemoteReady.new(@capture).handle(params)
      when :start_capture
        params.merge!({current_user_id: current_user.id})
        status, message = Video::CaptureWorkflow::StartCapture.new(@capture).handle(params)
      when :stop_capture
        params.merge!({current_user_id: current_user.id})
        status, message = Video::CaptureWorkflow::StopCapture.new(@capture).handle(params)
      end

      # next step based on current step result
      if status
        # for some reason `finish_wizard_path` below not working
        if step == steps.last
          redirect_to stream_path(@capture.stream)
        else
          render_wizard @capture
        end
      else
        # re-render the current step
        flash.now[:alert] = message
        render_wizard
      end
    end

    def finish_wizard_path
      stream_path(@capture.stream)
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_steps
        @capture = Capture.find(params[:capture_id])
        @stream = @capture.stream

        self.steps = [
          :set_details, :set_machines, :ping_nimki, :set_remote_ready,
          :start_capture, :stop_capture
        ]
      end

      def set_steps_ll
        @current_step = step
        @prev_step = steps.index(step) == 0 ? nil : steps[steps.index(step) - 1]
        @next_step = steps.index(step) == (steps.count - 1) ? nil : steps[steps.index(step) + 1]
      end

  end
end
