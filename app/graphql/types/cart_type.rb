module Types
  class CartType < Types::BaseObject
    implements Types::NodeType

    def self.authorized?(object, context)
      policy = CartPolicy.new(context[:current_user], object)
      policy.show?
    end

    field :guest_uuid, String
    field :items, [ Types::Cart::ItemType ], null: false
    field :total_cents, Integer, null: false

    def total_cents
      object.items.sum do |item|
        item.product_variant.effective_price * item.quantity
      end
    end
  end
end
