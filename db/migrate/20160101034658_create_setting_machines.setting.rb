# This migration comes from setting (originally 20160101031406)
class CreateSettingMachines < ActiveRecord::Migration
  def change
    create_table :setting_machines do |t|
      t.string :ztype
      t.string :zstate
      t.string :zcloud
      t.string :zdetails
      t.string :hostname
      t.string :ip

      t.timestamps null: false
    end
  end
end
