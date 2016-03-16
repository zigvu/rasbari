# This migration comes from kheer (originally 20160316002959)
class RemoveZstateFromKheerChiaModel < ActiveRecord::Migration
  def change
    remove_column :kheer_chia_models, :zstate, :string
  end
end
