# This migration comes from video (originally 20160105183823)
class CreateVideoClips < ActiveRecord::Migration
  def change
    create_table :video_clips do |t|
      t.integer :capture_id
      t.string :zstate
      t.integer :length
      t.integer :frame_number_start
      t.integer :frame_number_end

      t.timestamps null: false
    end
    add_index :video_clips, :capture_id
  end
end
