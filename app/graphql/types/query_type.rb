module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :me, resolver: Resolvers::MeResolver
    field :cart, resolver: Resolvers::CartResolver
    field :categories, resolver: Resolvers::CategoriesResolver
    field :product, resolver: Resolvers::ProductResolver
    field :products, resolver: Resolvers::ProductsResolver
    field :verify_cart, resolver: Resolvers::VerifyCartResolver
    field :admin_dashboard, resolver: Resolvers::Admin::DashboardResolver
    field :admin_orders, resolver: Resolvers::Admin::OrdersResolver
    field :admin_order, resolver: Resolvers::Admin::OrderResolver
  end
end
