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
    end

    # GET /capture_evaluations/new
    def new
      @capture_evaluation = CaptureEvaluation.new
      create_vars_for_new
    end

    # POST /capture_evaluations
    def create
      @capture_evaluation = CaptureEvaluation.new(capture_evaluation_params)
      @capture_evaluation.chia_model_id = params["chia_model_id_capEvaluation"].to_i
      @capture_evaluation.user_id = current_user.id
      status, _ = @capture_evaluation.samosaClient.isRemoteAlive?
      if status && @capture_evaluation.save
          @capture_evaluation.state.setConfiguring
          redirect_to @capture_evaluation, notice: 'Capture evaluation was successfully created.'
      else
        create_vars_for_new
        flash[:error] = 'Could not contact remote GPU machine or failed to save form'
        render :new
      end
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

      def create_vars_for_new
        @captures = []
        Video::Capture.all.each do |capture|
          @captures << ["#{capture.stream.name} - #{capture.id} - #{capture.comment}", capture.id]
        end
        @gpuMachines = Setting::Machine
          .where(ztype: Setting::MachineTypes.gpu)
          .where(zstate: Setting::MachineStates.ready)
          .pluck(:hostname, :id)
        @chiaModelsHierarchy = Kheer::ChiaModel.hierarchy
        @selectedMiniId = @capture_evaluation.chia_model_id
        if @selectedMiniId
          selectedMini = Kheer::ChiaModel.find(@selectedMiniId)
          @selectedMinorId = selectedMini.decorate.minorParent.id
          @selectedMajorId = selectedMini.decorate.majorParent.id
        end
      end

      # Only allow a trusted parameter "white list" through.
      def capture_evaluation_params
        params.require(:capture_evaluation).permit(:capture_id, :chia_model_id, :gpu_machine_id)
      end
  end
end
