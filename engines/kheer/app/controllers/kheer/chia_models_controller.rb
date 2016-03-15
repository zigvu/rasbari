require_dependency "kheer/application_controller"

module Kheer
  class ChiaModelsController < ApplicationController
    # Same permission model as for detectable
    authorize_actions_for Detectable
    authority_actions :minis => :read

    before_action :set_chia_model, only: [:minis, :show, :edit, :update, :destroy]

    # GET /chia_models/1/minis
    def minis
    end

    # GET /chia_models
    def index
      @chia_models = ChiaModel.where(minor_id: 0)
    end

    # GET /chia_models/1
    def show
      @curSelDets = Detectable.where(id: @chia_model.detectable_ids)
      parent = @chia_model.decorate.parent
      if @curSelDets.count == 0 && parent != nil
        @curSelDets = Detectable.where(id: parent.detectable_ids)
      end
      @othDets = Detectable.all - @curSelDets
      redirect_to minis_chia_model_path(@chia_model) if @chia_model.decorate.isMini?
    end

    # GET /chia_models/new
    def new
      @chia_model = ChiaModel.new
      if params['major_id']
        majorId = params['major_id'].to_i
        minorId = ChiaModel.where(major_id: majorId).pluck(:minor_id).max + 1
      else
        majorId = ChiaModel.all.pluck(:major_id).max || 0
        majorId += 1
        minorId = 0
      end
      @chia_model.major_id = majorId
      @chia_model.minor_id = minorId
    end

    # GET /chia_models/1/edit
    def edit
    end

    # POST /chia_models
    def create
      @chia_model = ChiaModel.new(chia_model_params)
      @chia_model.mini_id = 0
      if @chia_model.save
        @chia_model.state.setConfiguring
        redirect_to @chia_model, notice: 'Chia model was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /chia_models/1
    def update
      cmp = chia_model_params
      cmp['detectable_ids'] = cmp['detectable_ids'].map{|i| i.to_i}.uniq.sort if cmp['detectable_ids']
      if @chia_model.update(cmp)
        redirect_to @chia_model, notice: 'Chia model was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /chia_models/1
    def destroy
      @chia_model.destroy
      redirect_to chia_models_url, notice: 'Chia model was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_chia_model
        @chia_model = ChiaModel.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def chia_model_params
        params[:chia_model] ||= {detectable_ids: []}
        params.require(:chia_model).permit(:name, :description, :comment, :major_id, :minor_id, detectable_ids: [])
      end
  end
end
