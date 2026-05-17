module Mutations
  module Admin
    module Products
      class Create < Mutations::BaseMutation
        graphql_name "AdminCreateProduct"

        argument :attributes, Types::Product::AttributesInput, required: true

        field :product, Types::ProductType, null: false

        def authorized?(attributes:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(attributes:)
          attrs = attributes.to_h
          category = GlobalID.find(attrs.delete(:category_id))

          product = ::Admin::Products::Create.run(category:, attributes: attrs)
          { product: }
        end
      end
    end
  end
end
