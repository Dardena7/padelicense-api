class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :number, null: false
      t.string :status, null: false, default: "pending"
      t.integer :total_cents, null: false
      t.string :stripe_payment_intent_id
      t.jsonb :shipping_address_snapshot, null: false, default: {}

      t.timestamps
    end

    add_index :orders, :number, unique: true
    add_index :orders, :stripe_payment_intent_id, unique: true
  end
end
