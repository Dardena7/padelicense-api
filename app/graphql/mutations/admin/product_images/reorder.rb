module Mutations
  module Admin
    module ProductImages
      class Reorder < Mutations::BaseMutation
        graphql_name "AdminReorderProductImages"

        argument :product_id, ID, required: true, loads: Types::ProductType
        argument :image_ids, [ ID ], required: true

        field :images, [ Types::Product::ImageType ], null: false

        def authorized?(product:, image_ids:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(product:, image_ids:)
          images = ::Admin::ProductImages::Reorder.run(product:, image_ids:)
          { images: }
        end
      end
    end
  end
end
