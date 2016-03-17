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
      if @chia_model.decorate.isMini?
        redirect_to minis_chia_model_path(@chia_model.decorate.minorParent)
      else
        @curSelDets = Detectable.where(id: @chia_model.detectable_ids)
        parent = @chia_model.decorate.parent
        if @curSelDets.count == 0 && parent != nil
          @curSelDets = Detectable.where(id: parent.detectable_ids)
        end
        @othDets = Detectable.all - @curSelDets
      end
    end

    # GET /chia_models/new
    def new
      @chia_model = ChiaModel.new
      majorId = ChiaModel.all.pluck(:major_id).max || 0
      majorId += 1
      minorId = 0
      miniId = 0

      majorId = params['major_id'].to_i if params['major_id']

      if params['minor_id']
        minorId = params['minor_id'].to_i
      else
        mnrId = ChiaModel.where(major_id: majorId).pluck(:minor_id).max
        minorId = mnrId + 1 if mnrId
      end

      if params['mini_id']
        miniId = params['mini_id'].to_i
      else
        mnId = ChiaModel.where(major_id: majorId).where(minor_id: minorId).pluck(:mini_id).max
        miniId = mnId + 1 if mnId
      end

      @chia_model.major_id = majorId
      @chia_model.minor_id = minorId
      @chia_model.mini_id = miniId
    end

    # GET /chia_models/1/edit
    def edit
    end

    # POST /chia_models
    def create
      @chia_model = ChiaModel.new(chia_model_params)
      if @chia_model.decorate.isMini?
        @chia_model.detectable_ids = @chia_model.decorate.minorParent.detectable_ids
      end
      if @chia_model.save
        if @chia_model.decorate.isMini?
          iteration = Iteration.create(chia_model_id: @chia_model.id)
          iteration.state.setConfiguring
          iteration.type.setQuick
          redirect_to iteration_workflow_path(Wicked::FIRST_STEP, iteration_id: iteration.id)
        else
          redirect_to @chia_model, notice: 'Chia model was successfully created.'
        end
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
        params.require(:chia_model).permit(:name, :description, :comment, :major_id, :minor_id, :mini_id, detectable_ids: [])
      end
  end
end
