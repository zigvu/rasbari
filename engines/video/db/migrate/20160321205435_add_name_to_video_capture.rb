class AddNameToVideoCapture < ActiveRecord::Migration
  def change
    add_column :video_captures, :name, :string
  end
end
