class CreateVideoStreams < ActiveRecord::Migration
  def change
    create_table :video_streams do |t|
      t.string :stype
      t.string :sstate
      t.string :spriority
      t.string :name
      t.string :url
      t.integer :machine_id

      t.timestamps null: false
    end
  end
end
