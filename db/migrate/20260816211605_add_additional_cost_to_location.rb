class AddAdditionalCostToLocation < ActiveRecord::Migration[8.1]
  def change
    add_column :locations, :additional_cost, :float, default: 0.0
  end
end
