class CreateLineItems < ActiveRecord::Migration[7.2]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product_variant, null: false, foreign_key: true
      t.string :product_name, null: false
      t.string :variant_name, null: false
      t.integer :unit_price_cents, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
