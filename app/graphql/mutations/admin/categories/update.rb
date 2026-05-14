module Mutations
  module Admin
    module Categories
      class Update < Mutations::BaseMutation
        graphql_name "AdminUpdateCategory"

        argument :category_id, ID, required: true, loads: Types::CategoryType
        argument :translations, [ Types::Category::TranslationInput ], required: true
        argument :parent_id, ID, required: false, loads: Types::CategoryType, as: :parent
        argument :position, Integer, required: false

        field :category, Types::CategoryType, null: false

        def authorized?(category:, translations:, parent: nil, position: nil)
          policy = AdminPolicy.new(context[:current_user], nil)
          raise GraphQL::ExecutionError, "Not authorized" unless policy.access?

          true
        end

        def resolve(category:, translations:, parent: nil, position: nil)
          updated = ::Admin::Categories::Update.run(
            category:,
            translations: translations.map(&:to_h),
            parent:,
            position:
          )
          { category: updated }
        end
      end
    end
  end
end
