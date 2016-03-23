require_dependency "kheer/application_controller"

module Kheer
  class CaptureEvaluationsController < ApplicationController
    authorize_actions_for Detectable
    before_action :set_capture_evaluation, only: [:show, :destroy]

    # GET /capture_evaluations
    def index
      @activeEvaluations = CaptureEvaluation
          .where(:zstate.ne => Kheer::CaptureEvaluationStates.evaluated)
      @inactiveEvaluations = CaptureEvaluation
          .where(zstate: Kheer::CaptureEvaluationStates.evaluated)
    end

    # GET /capture_evaluations/1
    def show
      if !@capture_evaluation.state.isEvaluated?
        redirect_to capture_evaluation_workflow_path(
          Wicked::FIRST_STEP, capture_evaluation_id: @capture_evaluation.id
        )
      end
    end

    # GET /capture_evaluations/new
    def new
      capture_evaluation = CaptureEvaluation.create(user_id: current_user.id)
      capture_evaluation.state.setConfiguring
      redirect_to capture_evaluation_workflow_path(
        Wicked::FIRST_STEP, capture_evaluation_id: capture_evaluation.id
      )
    end

    # DELETE /capture_evaluations/1
    def destroy
      if @capture_evaluation.state.isConfiguring?
        @capture_evaluation.destroy
        redirect_to capture_evaluations_url, notice: 'Capture evaluation was successfully destroyed.'
      else
        redirect_to capture_evaluations_url, alert: 'Could not cancel capture evaluation that has started.'
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_capture_evaluation
        @capture_evaluation = CaptureEvaluation.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def capture_evaluation_params
        params.require(:capture_evaluation).permit(:capture_id, :chia_model_id, :gpu_machine_id)
      end
  end
end
