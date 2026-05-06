class AddDefaultToAddresses < ActiveRecord::Migration[7.2]
  def change
    add_column :addresses, :default, :boolean, default: false, null: false
  end
end
