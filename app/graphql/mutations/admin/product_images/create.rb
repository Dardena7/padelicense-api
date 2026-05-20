module Mutations
  module Admin
    module ProductImages
      class Create < Mutations::BaseMutation
        graphql_name "AdminCreateProductImage"

        argument :product_id, ID, required: true, loads: Types::ProductType
        argument :blob_signed_id, String, required: true
        argument :alt_text, String, required: false

        field :image, Types::Product::ImageType, null: false

        def authorized?(product:, blob_signed_id:, alt_text: nil)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(product:, blob_signed_id:, alt_text: nil)
          image = ::Admin::ProductImages::Create.run(
            product:, blob_signed_id:, alt_text:
          )
          { image: }
        end
      end
    end
  end
end
