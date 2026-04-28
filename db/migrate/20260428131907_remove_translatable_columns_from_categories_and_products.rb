class RemoveTranslatableColumnsFromCategoriesAndProducts < ActiveRecord::Migration[7.2]
  def change
    remove_index :categories, :slug
    remove_column :categories, :name, :string
    remove_column :categories, :slug, :string
    remove_column :categories, :description, :text

    remove_index :products, :slug
    remove_column :products, :name, :string
    remove_column :products, :slug, :string
    remove_column :products, :description, :text
  end
end
