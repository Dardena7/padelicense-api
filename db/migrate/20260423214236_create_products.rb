class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.string :brand
      t.integer :base_price_cents, null: false
      t.string :status, null: false, default: "draft"
      t.boolean :featured, null: false, default: false

      t.timestamps
    end
    add_index :products, :slug, unique: true
  end
end
