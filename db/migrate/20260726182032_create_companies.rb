class CreateCompanies < ActiveRecord::Migration[8.1]
  def change
    create_table :companies do |t|
      t.references :renter, null: false, foreign_key: true
      t.string :name
      t.string :address
      t.string :country
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
