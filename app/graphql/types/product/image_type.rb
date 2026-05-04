module Types
  module Product
    class ImageType < Types::BaseObject
      graphql_name "ProductImage"
      implements Types::NodeType

      field :image_url, String, null: false
      field :position, Integer, null: false
      field :alt_text, String
    end
  end
end
