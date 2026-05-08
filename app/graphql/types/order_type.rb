module Types
  class OrderType < Types::BaseObject
    implements Types::NodeType

    def self.authorized?(object, context)
      policy = OrderPolicy.new(context[:current_user], object)
      policy.show?
    end

    field :uuid, String, null: false
    field :number, String, null: false
    field :status, Types::Order::StatusEnum, null: false
    field :total_cents, Integer, null: false
    field :stripe_payment_intent_id, String
    field :shipping_address_snapshot, GraphQL::Types::JSON, null: false
    field :line_items, [ Types::Order::LineItemType ], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
