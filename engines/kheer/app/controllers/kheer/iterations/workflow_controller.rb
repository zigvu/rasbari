require_dependency "kheer/application_controller"

module Kheer
  class Iterations::WorkflowController < ApplicationController
    include Wicked::Wizard
    before_action :set_steps
    before_action :setup_wizard

    before_action :set_steps_ll, only: [:show, :update]

    def show
      case step
      when :select_detectables
        @workflowObj = Kheer::IterationWorkflow::SelectDetectables.new(@iteration)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :select_num_iters
        @workflowObj = Kheer::IterationWorkflow::SelectNumIters.new(@iteration)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :set_machines
        @workflowObj = Kheer::IterationWorkflow::SetMachines.new(@iteration)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :ping_nimki
        @workflowObj = Kheer::IterationWorkflow::PingNimki.new(@iteration)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      end
      render_wizard
    end

    def update
      status = false
      trace = "Could not complete step - unknown workflow step"

      case step
      when :select_detectables
        status, message = Kheer::IterationWorkflow::SelectDetectables.new(@iteration).handle(params)
      when :select_num_iters
        prms = params["iteration"]
        status, message = Kheer::IterationWorkflow::SelectNumIters.new(@iteration).handle(prms)
      when :set_machines
        prms = params["iteration"]
        status, message = Kheer::IterationWorkflow::SetMachines.new(@iteration).handle(prms)
      when :ping_nimki
        status, message = Kheer::IterationWorkflow::PingNimki.new(@iteration).handle(params)
      end

      # next step based on current step result
      if status
        if step == steps.last
          redirect_to chia_model_path(@chia_model)
        else
          render_wizard @iteration
        end
      else
        # re-render the current step
        flash[:alert] = trace
        jump_to(previous_step)
        render_wizard @iteration
      end
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_steps
        @iteration = Iteration.find(params[:iteration_id])
        @chia_model = @iteration.chia_model

        self.steps = [:select_detectables, :select_num_iters,
          :set_machines, :ping_nimki]
      end

      def set_steps_ll
        @current_step = step
        @prev_step = steps.index(step) == 0 ? nil : steps[steps.index(step) - 1]
        @next_step = steps.index(step) == (steps.count - 1) ? nil : steps[steps.index(step) + 1]
      end

  end
end
