module Types
  class MutationType < Types::BaseObject
    field :add_item_to_cart, mutation: Mutations::Cart::AddItem
    field :update_cart_item, mutation: Mutations::Cart::UpdateItem
    field :remove_item_from_cart, mutation: Mutations::Cart::RemoveItem
    field :claim_guest_cart, mutation: Mutations::Cart::Claim
    field :create_user_order, mutation: Mutations::Orders::CreateUser
    field :create_guest_order, mutation: Mutations::Orders::CreateGuest
    field :create_address, mutation: Mutations::Addresses::Create
    field :update_address, mutation: Mutations::Addresses::Update
    field :delete_address, mutation: Mutations::Addresses::Delete
    field :update_profile, mutation: Mutations::Users::UpdateProfile
    field :admin_update_order_status, mutation: Mutations::Admin::Orders::UpdateStatus
  end
end
