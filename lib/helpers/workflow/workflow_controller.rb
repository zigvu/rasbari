require_dependency "sample_engine/application_controller"

module SampleEngine
  class Trackers::WorkflowController < ApplicationController
    include Wicked::Wizard
    before_action :set_steps
    before_action :setup_wizard

    before_action :set_steps_ll, only: [:show, :update]

    def show
      case step XXX_REPLACE_SHOW_STEPS_XXX
      end
      render_wizard
    end

    def update
      status = false
      message = "Could not complete step - please check for mistakes"

      case step XXX_REPLACE_UPDATE_STEPS_XXX
      end

      # next step based on current step result
      if status
        if step == steps.last
          redirect_to parent_path(@parent)
        else
          render_wizard @capture
        end
      else
        # re-render the current step
        flash.now[:alert] = message
        render_wizard
      end
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_steps
        @tracker = Tracker.find(params[:tracker_id])
        @parent = @tracker.parent

        self.steps = [XXX_REPLACE_SET_STEPS_XXX]
      end

      def set_steps_ll
        @current_step = step
        @prev_step = steps.index(step) == 0 ? nil : steps[steps.index(step) - 1]
        @next_step = steps.index(step) == (steps.count - 1) ? nil : steps[steps.index(step) + 1]
      end

  end
end
