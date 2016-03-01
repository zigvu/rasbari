require_dependency "analysis/application_controller"

module Analysis
  class MiningsController < ApplicationController
    before_action :set_mining, only: [:show, :edit, :update, :destroy]

    # GET /minings
    def index
      @minings = Mining.all
    end

    # GET /minings/1
    def show
      if @mining.state.isBeforeCompleteSetup?
        if @mining.type.isSequenceViewer?
          redirect_to mining_sequence_viewer_workflow_path(Wicked::FIRST_STEP, mining_id: @mining.id)
        end
      end
    end

    # GET /minings/new
    def new
      @mining = Mining.new
      @miningTypes = Analysis::MiningTypes.to_h
    end

    # GET /minings/1/edit
    def edit
      @miningTypes = Analysis::MiningTypes.to_h
    end

    # POST /minings
    def create
      @mining = Mining.new(mining_params)
      @mining.user_id = current_user.id
      if @mining.save
        @mining.state.setStartSetup
        redirect_to @mining, notice: 'Mining was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /minings/1
    def update
      if @mining.update(mining_params)
        redirect_to @mining, notice: 'Mining was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /minings/1
    def destroy
      @mining.destroy
      redirect_to minings_url, notice: 'Mining was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_mining
        @mining = Mining.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def mining_params
        params.require(:mining).permit(:name, :description, :ztype)
      end
  end
end
