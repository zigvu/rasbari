require_dependency "kheer/application_controller"

module Kheer
  class IterationsController < ApplicationController
    authorize_actions_for ChiaModel
    before_action :set_iteration, only: [:show]

    # GET /iterations/1
    def show
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_iteration
        @iteration = Iteration.find(params[:id])
        @chia_model = @iteration.chia_model
      end
  end
end
