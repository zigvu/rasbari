class CreateSettingMachines < ActiveRecord::Migration
  def change
    create_table :setting_machines do |t|
      t.string :ztype
      t.string :zstate
      t.string :cloud
      t.string :hostname
      t.string :ip
      t.string :zdetails

      t.timestamps null: false
    end
  end
end
