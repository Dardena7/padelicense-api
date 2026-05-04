class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :label
      t.string :line1, null: false
      t.string :line2
      t.string :city, null: false
      t.string :postal_code, null: false
      t.string :country_iso, null: false

      t.timestamps
    end
  end
end
