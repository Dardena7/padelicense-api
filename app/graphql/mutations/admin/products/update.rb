module Mutations
  module Admin
    module Products
      class Update < Mutations::BaseMutation
        graphql_name "AdminUpdateProduct"

        argument :product_id, ID, required: true, loads: Types::ProductType
        argument :attributes, Types::Product::AttributesInput, required: true

        field :product, Types::ProductType, null: false

        def authorized?(product:, attributes:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(product:, attributes:)
          attrs = attributes.to_h
          category = attrs[:category_id] ? GlobalID.find(attrs.delete(:category_id)) : nil

          updated = ::Admin::Products::Update.run(product:, category:, attributes: attrs)
          { product: updated }
        end
      end
    end
  end
end
