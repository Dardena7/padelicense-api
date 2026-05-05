module Mutations
  module Addresses
    class Delete < Mutations::BaseMutation
      graphql_name "DeleteAddress"

      argument :address_id, ID, required: true, loads: Types::AddressType

      field :address, Types::AddressType, null: false

      def self.authorized?(object, context)
        context[:current_user].present?
      end

      def resolve(address:)
        result = ::Addresses::Delete.run(address:)

        { address: result }
      end
    end
  end
end
