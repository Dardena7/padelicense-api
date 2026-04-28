class CreateCategoryTranslations < ActiveRecord::Migration[7.2]
  def change
    create_table :category_translations do |t|
      t.references :category, null: false, foreign_key: true, index: false
      t.string :locale, null: false
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps null: false
    end

    add_index :category_translations, [ :category_id, :locale ], unique: true
    add_index :category_translations, [ :locale, :slug ], unique: true
  end
end
