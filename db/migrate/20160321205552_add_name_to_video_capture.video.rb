# This migration comes from video (originally 20160321205435)
class AddNameToVideoCapture < ActiveRecord::Migration
  def change
    add_column :video_captures, :name, :string
  end
end
