require_dependency "analysis/application_controller"

module Analysis
  class Api::V1::FramesController < ApplicationController
    before_filter :ensure_json_format

    # POST api/v1/frames/update_annotations
    def update_annotations
      annotationParams = Analysis::AnnotationJsonifier::ParamsParser.new(params[:annotations])
      annotationSaver = Analysis::AnnotationJsonifier::AnnotationSaver.new(annotationParams, current_user)
      saveResults = annotationSaver.save()
      render json: saveResults.to_json
    end

    # GET api/v1/frames/localization_data
    def localization_data
      localizationParams = Analysis::LocalizationJsonifier::ParamsParser.new(params[:localization])
      formatted = Analysis::LocalizationJsonifier::ServeLocalizations.new(localizationParams).formatted()

      render json: formatted.to_json
    end

    # GET api/v1/frames/heatmap_data
    def heatmap_data
      heatmapParams = Analysis::HeatmapJsonifier::ParamsParser.new(params[:heatmap])
      formatted = Analysis::HeatmapJsonifier::ServeHeatmap.new(heatmapParams).formatted()

      render json: formatted.to_json
    end

  end
end
