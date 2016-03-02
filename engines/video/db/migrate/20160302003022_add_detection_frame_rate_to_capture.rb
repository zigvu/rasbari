class AddDetectionFrameRateToCapture < ActiveRecord::Migration
  def change
    add_column :video_captures, :detection_frame_rate, :float
  end
end
