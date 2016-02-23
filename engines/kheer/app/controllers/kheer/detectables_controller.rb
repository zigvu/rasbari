require_dependency "kheer/application_controller"

module Kheer
  class DetectablesController < ApplicationController
    authorize_actions_for Detectable
    before_action :set_detectable, only: [:show, :edit, :update, :destroy]

    # GET /detectables
    def index
      @detectables = Detectable.all
    end

    # GET /detectables/1
    def show
    end

    # GET /detectables/new
    def new
      @detectable = Detectable.new
      @detectableTypes = Kheer::DetectableTypes.to_h
    end

    # GET /detectables/1/edit
    def edit
      @detectableTypes = Kheer::DetectableTypes.to_h
    end

    # POST /detectables
    def create
      @detectable = Detectable.new(detectable_params)

      if @detectable.save
        redirect_to @detectable, notice: 'Detectable was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /detectables/1
    def update
      if @detectable.update(detectable_params)
        redirect_to @detectable, notice: 'Detectable was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /detectables/1
    def destroy
      @detectable.destroy
      redirect_to detectables_url, notice: 'Detectable was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_detectable
        @detectable = Detectable.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def detectable_params
        params.require(:detectable).permit(:name, :pretty_name, :description, :ztype)
      end
  end
end
