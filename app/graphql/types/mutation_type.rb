module Types
  class MutationType < Types::BaseObject
    field :add_item_to_cart, mutation: Mutations::Cart::AddItem
    field :update_cart_item, mutation: Mutations::Cart::UpdateItem
    field :remove_item_from_cart, mutation: Mutations::Cart::RemoveItem
    field :claim_guest_cart, mutation: Mutations::Cart::Claim
  end
end
