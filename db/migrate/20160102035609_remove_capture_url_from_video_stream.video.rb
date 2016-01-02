# This migration comes from video (originally 20160102035551)
class RemoveCaptureUrlFromVideoStream < ActiveRecord::Migration
  def change
    remove_column :video_streams, :capture_url, :string
  end
end
