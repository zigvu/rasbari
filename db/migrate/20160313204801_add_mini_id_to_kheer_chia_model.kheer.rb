# This migration comes from kheer (originally 20160313204710)
class AddMiniIdToKheerChiaModel < ActiveRecord::Migration
  def change
    add_column :kheer_chia_models, :mini_id, :integer
  end
end
