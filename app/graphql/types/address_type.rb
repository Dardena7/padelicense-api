module Types
  class AddressType < Types::BaseObject
    implements Types::NodeType

    def self.authorized?(object, context)
      policy = AddressPolicy.new(context[:current_user], object)
      policy.show?
    end

    field :label, String
    field :line1, String, null: false
    field :line2, String
    field :city, String, null: false
    field :postal_code, String, null: false
    field :country_iso, String, null: false
  end
end
