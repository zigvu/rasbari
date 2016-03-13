class AddMiniIdToKheerChiaModel < ActiveRecord::Migration
  def change
    add_column :kheer_chia_models, :mini_id, :integer
  end
end
