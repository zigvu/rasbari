class CreateVideoCaptures < ActiveRecord::Migration
  def change
    create_table :video_captures do |t|
      t.integer :stream_id
      t.integer :storage_machine_id
      t.integer :capture_machine_id
      t.string :capture_url
      t.text :comment
      t.integer :width
      t.integer :height
      t.float :playback_frame_rate
      t.integer :started_by
      t.integer :stopped_by
      t.datetime :started_at
      t.datetime :stopped_at

      t.timestamps null: false
    end
    add_index :video_captures, :stream_id
    add_index :video_captures, :storage_machine_id
    add_index :video_captures, :capture_machine_id
  end
end
