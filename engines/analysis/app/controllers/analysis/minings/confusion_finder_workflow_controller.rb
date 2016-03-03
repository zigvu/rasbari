require_dependency "analysis/application_controller"

module Analysis
  class Minings::ConfusionFinderWorkflowController < ApplicationController
    include Wicked::Wizard
    before_action :set_steps
    before_action :setup_wizard

    before_action :set_steps_ll, only: [:show, :update]

    def show
      case step
      when :set_chia_models
        @workflowObj = Analysis::ConfusionFinderWorkflow::SetChiaModels.new(@mining)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :set_clips
        @workflowObj = Analysis::ConfusionFinderWorkflow::SetClips.new(@mining)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :set_confusions
        @workflowObj = Analysis::ConfusionFinderWorkflow::SetConfusions.new(@mining)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      when :create_sets
        @workflowObj = Analysis::ConfusionFinderWorkflow::CreateSets.new(@mining)
        @workflowObj.canSkip ? skip_step : @workflowObj.serve
      end

      render_wizard
    end

    def update
      status = false
      trace = "Could not complete step - unknown workflow step"

      case step
      when :set_chia_models
        status, trace = Analysis::ConfusionFinderWorkflow::SetChiaModels.new(@mining).handle(params)
      when :set_clips
        status, trace = Analysis::ConfusionFinderWorkflow::SetClips.new(@mining).handle(params)
      when :set_confusions
        status, trace = Analysis::ConfusionFinderWorkflow::SetConfusions.new(@mining).handle(params)
      when :create_sets
        status, trace = Analysis::ConfusionFinderWorkflow::CreateSets.new(@mining).handle(params)
      end

      # next step based on current step result
      if status
        # for some reason `finish_wizard_path` below not working
        if step == steps.last
          redirect_to mining_path(@mining)
        else
          render_wizard @mining
        end
      else
        # re-render the current step
        flash.now[:alert] = trace
        render_wizard
      end
    end

    def finish_wizard_path
      redirect_to mining_path(@mining)
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_steps
        @mining = Mining.find(params[:mining_id])

        self.steps = [
          :set_chia_models, :set_clips, :set_confusions, :create_sets
        ]
      end

      def set_steps_ll
        @current_step = step
        @prev_step = steps.index(step) == 0 ? nil : steps[steps.index(step) - 1]
        @next_step = steps.index(step) == (steps.count - 1) ? nil : steps[steps.index(step) + 1]
      end

  end
end
