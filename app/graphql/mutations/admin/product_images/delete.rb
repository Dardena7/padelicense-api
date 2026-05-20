module Mutations
  module Admin
    module ProductImages
      class Delete < Mutations::BaseMutation
        graphql_name "AdminDeleteProductImage"

        argument :image_id, ID, required: true, loads: Types::Product::ImageType

        field :deleted_id, ID, null: false

        def authorized?(image:)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(image:)
          id = image.id
          ::Admin::ProductImages::Delete.run(image:)
          { deleted_id: id }
        end
      end
    end
  end
end
