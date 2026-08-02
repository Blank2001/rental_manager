class AddFieldsToVehicle < ActiveRecord::Migration[8.1]
  def change
    add_column :vehicles, :minimum_days, :integer, default: 1
    add_column :vehicles, :published, :boolean, default: false
  end
end
