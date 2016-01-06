require_dependency "sample_engine/application_controller"

module SampleEngine
  class TrackersController < ApplicationController
    # TODO: change if different authority
    authorize_actions_for Parent
    before_action :set_tracker, only: [:show, :destroy]

    # GET /trackers/1
    def show
    end

    # GET /trackers/new
    def new
      parent = Parent.find(params[:parent_id])
      tracker = parent.trackers.create
      redirect_to tracker_workflow_path(Wicked::FIRST_STEP, tracker_id: tracker.id)
    end

    # DELETE /trackers/1
    def destroy
      @tracker.destroy
      redirect_to parent_path(@parent), notice: 'Tracker was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_tracker
        @tracker = Tracker.find(params[:id])
        @parent = @tracker.parent
      end
  end
end
