require_dependency "analysis/application_controller"

module Analysis
  class Api::V1::MiningsController < ApplicationController
    before_filter :ensure_json_format
    before_action :set_mining

    # GET api/v1/minings/set_details
    def set_details
      m = Analysis::CommonJsonifier::SetDetails.new(@mining, @setId)
      render json: m.formatted.to_json
    end

    # GET api/v1/minings/full_localizations
    def full_localizations
      m = @mTypeModule::FullLocalizations.new(@mining, @setId)
      render json: m.formatted.to_json
    end

    # GET api/v1/minings/full_annotations
    def full_annotations
      m = Analysis::CommonJsonifier::FullAnnotations.new(@mining, @setId)
      render json: m.formatted.to_json
    end

    private
      def set_mining
        miningId = params['mining_id']
        @setId = params['set_id']
        @mining = Mining.find(miningId)

        if @mining.type.isSequenceViewer?
          @mTypeModule = Analysis::SequenceViewerJsonifier
        end
      end

  end
end
