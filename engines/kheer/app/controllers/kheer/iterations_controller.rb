require_dependency "kheer/application_controller"

module Kheer
  class IterationsController < ApplicationController
    authorize_actions_for Detectable
    before_action :set_iteration, only: [:show]

    # GET /iterations/1
    def show
      @detAnnoCountMap = ActiveSupport::OrderedHash.new
      chia_model = @iteration.chia_model
      allCmIds = chia_model.decorate.ancestorIds + [chia_model.id]
      Detectable.where(id: @iteration.detectable_ids).each do |det|
        @detAnnoCountMap[det] = Annotation.in(chia_model_id: allCmIds)
            .where(detectable_id: det.id).count
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_iteration
        @iteration = Iteration.find(params[:id])
      end
  end
end
