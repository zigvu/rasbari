class RemoveZstateFromKheerChiaModel < ActiveRecord::Migration
  def change
    remove_column :kheer_chia_models, :zstate, :string
  end
end
