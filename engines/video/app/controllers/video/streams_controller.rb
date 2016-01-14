require_dependency "video/application_controller"

module Video
  class StreamsController < ApplicationController
    authorize_actions_for Stream
    before_action :set_stream, only: [:show, :edit, :update, :destroy]

    # GET /streams
    def index
      @activeStreams = Stream.where.not(zstate: Video::StreamStates.stopped)
      @inactiveStreams = Stream.where(zstate: Video::StreamStates.stopped)
    end

    # GET /streams/1
    def show
      @activeCaptures = @stream.captures.where(stopped_at: nil).order(created_at: :desc)
      @stoppedCaptures = @stream.captures.where.not(stopped_at: nil).order(stopped_at: :desc)
    end

    # GET /streams/new
    def new
      @stream = Stream.new
      @streamTypes = Video::StreamTypes.to_h
    end

    # GET /streams/1/edit
    def edit
      @streamTypes = Video::StreamTypes.to_h
    end

    # POST /streams
    def create
      @stream = Stream.new(stream_params)
      if @stream.save
        @stream.state.setStopped
        @stream.priority.setNone
        redirect_to @stream, notice: 'Stream was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /streams/1
    def update
      if @stream.update(stream_params)
        redirect_to @stream, notice: 'Stream was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /streams/1
    def destroy
      @stream.destroy
      redirect_to streams_url, notice: 'Stream was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_stream
        @stream = Stream.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def stream_params
        params.require(:stream).permit(:ztype, :zstate, :zpriority, :name, :base_url)
      end
  end
end
