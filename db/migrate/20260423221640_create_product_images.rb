class CreateProductImages < ActiveRecord::Migration[7.2]
  def change
    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
      t.references :product_variant, null: true, foreign_key: true
      t.string :image_url, null: false
      t.integer :position, null: false, default: 0
      t.string :alt_text

      t.timestamps
    end
  end
end
