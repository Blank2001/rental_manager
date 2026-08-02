class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.references :customer, null: true, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.date :collection_date
      t.date :return_date
      t.string :collection_location
      t.string :return_location
      t.string :status
      t.string :res_type, default: "online"
      t.json :cost, default: {}

      t.timestamps
    end
  end
end
