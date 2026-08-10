class CreateLocations < ActiveRecord::Migration[8.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :latitude
      t.string :longitude
      t.boolean :is_default
      t.boolean :allows_collection, default: true
      t.boolean :allows_return, default: true
      t.boolean :hidden, default: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
