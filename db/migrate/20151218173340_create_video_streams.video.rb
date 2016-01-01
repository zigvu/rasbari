# This migration comes from video (originally 20151217210040)
class CreateVideoStreams < ActiveRecord::Migration
  def change
    create_table :video_streams do |t|
      t.string :ztype
      t.string :zstate
      t.string :zpriority
      t.string :name
      t.string :base_url
      t.string :capture_url

      t.timestamps null: false
    end
  end
end
