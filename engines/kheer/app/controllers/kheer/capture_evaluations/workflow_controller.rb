require_dependency "kheer/application_controller"

module Kheer
  class CaptureEvaluations::WorkflowController < ApplicationController
    include Wicked::Wizard
    before_action :set_steps
    before_action :setup_wizard

    before_action :set_steps_ll, only: [:show, :update]

    def show
      case step
      when :set_details
        @workflowObj = Kheer::CaptureEvaluationWorkflow::SetDetails.new(@capture_evaluation)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :set_machines
        @workflowObj = Kheer::CaptureEvaluationWorkflow::SetMachines.new(@capture_evaluation)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :ping_nimki
        @workflowObj = Kheer::CaptureEvaluationWorkflow::PingNimki.new(@capture_evaluation)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :monitor_progress
        @workflowObj = Kheer::CaptureEvaluationWorkflow::MonitorProgress.new(@capture_evaluation)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      end
      render_wizard
    end

    def update
      status = false
      trace = "Could not complete step - unknown workflow step"

      case step
      when :set_details
        status, trace = Kheer::CaptureEvaluationWorkflow::SetDetails.new(@capture_evaluation).handle(params)
      when :set_machines
        status, trace = Kheer::CaptureEvaluationWorkflow::SetMachines.new(@capture_evaluation).handle(params)
      when :ping_nimki
        status, trace = Kheer::CaptureEvaluationWorkflow::PingNimki.new(@capture_evaluation).handle(params)
      when :monitor_progress
        status, trace = Kheer::CaptureEvaluationWorkflow::MonitorProgress.new(@capture_evaluation).handle(params)
      end

      # next step based on current step result
      if status
        if step == steps.last
          redirect_to capture_evaluations_path
        else
          render_wizard @capture_evaluation
        end
      else
        # re-render the current step
        flash[:alert] = trace
        jump_to(step)
        render_wizard @capture_evaluation
      end
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_steps
        @capture_evaluation = CaptureEvaluation.find(params[:capture_evaluation_id])

        self.steps = [:set_details, :set_machines, :ping_nimki, :monitor_progress]
      end

      def set_steps_ll
        @current_step = step
        @prev_step = steps.index(step) == 0 ? nil : steps[steps.index(step) - 1]
        @next_step = steps.index(step) == (steps.count - 1) ? nil : steps[steps.index(step) + 1]
      end

  end
end
