module Types
  class CartType < Types::BaseObject
    def self.authorized?(object, context)
      policy = CartPolicy.new(context[:current_user], object)
      policy.show?
    end

    field :id, ID, null: false
    field :items, [ Types::Cart::ItemType ], null: false
    field :total_cents, Integer, null: false

    def total_cents
      object.items.sum do |item|
        item.product_variant.effective_price * item.quantity
      end
    end
  end
end
