module Mutations
  module Addresses
    class Create < Mutations::BaseMutation
      graphql_name "CreateAddress"

      argument :input, Types::AddressInput, required: true

      field :address, Types::AddressType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(input:)
        user = context[:current_user]

        address = ::Addresses::Create.run(user:, attributes: input.to_h)

        { address: }
      end
    end
  end
end
