class AddGuestUuidToCartsAndMakeUserNullable < ActiveRecord::Migration[7.2]
  def change
    add_column :carts, :guest_uuid, :uuid, default: "gen_random_uuid()"
    add_index :carts, :guest_uuid, unique: true

    remove_index :carts, :user_id
    change_column_null :carts, :user_id, true
    add_index :carts, :user_id, unique: true, where: "user_id IS NOT NULL"
  end
end
