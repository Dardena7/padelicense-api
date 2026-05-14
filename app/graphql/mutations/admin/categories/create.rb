module Mutations
  module Admin
    module Categories
      class Create < Mutations::BaseMutation
        graphql_name "AdminCreateCategory"

        argument :translations, [ Types::Category::TranslationInput ], required: true
        argument :parent_id, ID, required: false, loads: Types::CategoryType
        argument :position, Integer, required: false

        field :category, Types::CategoryType, null: false

        def authorized?(translations:, parent: nil, position: nil)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(translations:, parent: nil, position: nil)
          category = ::Admin::Categories::Create.run(
            translations: translations.map(&:to_h),
            parent:,
            position:
          )
          { category: }
        end
      end
    end
  end
end
