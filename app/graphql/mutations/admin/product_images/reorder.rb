module Mutations
  module Admin
    module ProductImages
      class Reorder < Mutations::BaseMutation
        graphql_name "AdminReorderProductImages"

        argument :product_id, ID, required: true, loads: Types::ProductType
        argument :image_ids, [ ID ], required: true, loads: Types::Product::ImageType, as: :images

        field :images, [ Types::Product::ImageType ], null: false

        def authorized?(product:, images:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(product:, images:)
          ordered_ids = images.map(&:id)
          result = ::Admin::ProductImages::Reorder.run(product:, image_ids: ordered_ids)
          { images: result }
        end
      end
    end
  end
end
