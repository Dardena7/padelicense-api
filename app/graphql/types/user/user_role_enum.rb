module Types
  class UserRoleEnum < Types::BaseEnum
    graphql_name "UserRole"
    description "Role of a user"

    value "CUSTOMER", "Regular customer", value: User::CUSTOMER
    value "ADMIN", "Administrator with full access", value: User::ADMIN
  end
end
