module Mutations
  module Addresses
    class Update < Mutations::BaseMutation
      graphql_name "UpdateAddress"

      argument :address_id, ID, required: true, loads: Types::AddressType
      argument :input, Types::AddressInput, required: true

      field :address, Types::AddressType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(address:, input:)
        result = ::Addresses::Update.run(address:, attributes: input.to_h)

        { address: result }
      end
    end
  end
end
