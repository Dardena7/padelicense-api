module Types
  class AddressInput < Types::BaseInputObject
    graphql_name "AddressInput"

    argument :label, String, required: false
    argument :line1, String, required: true
    argument :line2, String, required: false
    argument :city, String, required: true
    argument :postal_code, String, required: true
    argument :country_iso, String, required: true
    argument :default, Boolean, required: false
  end
end
