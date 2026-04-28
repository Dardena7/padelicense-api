class CreateProductTranslations < ActiveRecord::Migration[7.2]
  def change
    create_table :product_translations do |t|
      t.references :product, null: false, foreign_key: true, index: false
      t.string :locale, null: false
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps null: false
    end

    add_index :product_translations, [ :product_id, :locale ], unique: true
    add_index :product_translations, [ :locale, :slug ], unique: true
  end
end
