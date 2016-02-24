# This migration comes from kheer (originally 20160223211236)
class CreateKheerChiaModels < ActiveRecord::Migration
  def change
    create_table :kheer_chia_models do |t|
      t.string :name
      t.string :description
      t.string :comment
      t.integer :major_id
      t.integer :minor_id
      t.text :detectable_ids
      t.string :zstate

      t.timestamps null: false
    end
  end
end
