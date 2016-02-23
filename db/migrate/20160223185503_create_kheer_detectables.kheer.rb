# This migration comes from kheer (originally 20160223184825)
class CreateKheerDetectables < ActiveRecord::Migration
  def change
    create_table :kheer_detectables do |t|
      t.string :name
      t.string :pretty_name
      t.string :description
      t.string :ztype

      t.timestamps null: false
    end
  end
end
