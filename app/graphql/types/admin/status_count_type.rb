module Types
  module Admin
    class StatusCountType < Types::BaseObject
      graphql_name "AdminStatusCount"

      field :status, String, null: false
      field :count, Integer, null: false
    end
  end
end
