class RemoveCaptureUrlFromVideoStream < ActiveRecord::Migration
  def change
    remove_column :video_streams, :capture_url, :string
  end
end
