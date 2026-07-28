class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.references :company, null: false, foreign_key: true
      t.string :category
      t.string :brand
      t.string :model
      t.integer :year
      t.string :transmission_type
      t.string :fuel_type
      t.integer :seats
      t.integer :doors
      t.integer :daily_rate
      t.float :weekly_rate
      t.float :monthly_rate
      t.float :security_deposit
      t.boolean :security_deposit_applicable
      t.string :status

      t.timestamps
    end
  end
end
