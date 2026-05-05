module Carts
  class Verify < BaseUseCase
    EMPTY_CART = "empty_cart".freeze
    PRODUCT_UNAVAILABLE = "product_unavailable".freeze
    INSUFFICIENT_STOCK = "insufficient_stock".freeze
    ISSUE_TYPES = [ EMPTY_CART, PRODUCT_UNAVAILABLE, INSUFFICIENT_STOCK ].freeze

    def initialize(cart:)
      @cart = cart
    end

    private

    def call
      items = @cart.items.includes(product_variant: :product)

      return { valid: false, issues: [ { type: EMPTY_CART } ] } if items.empty?

      issues = items.flat_map { |item| check_item(item) }

      { valid: issues.empty?, issues: }
    end

    def check_item(item)
      variant = item.product_variant
      product = variant.product
      issues = []

      unless product.active?
        issues << { type: PRODUCT_UNAVAILABLE, cart_item_id: item.id, product_name: product.name }
      end

      if variant.stock_quantity < item.quantity
        issues << {
          type: INSUFFICIENT_STOCK,
          cart_item_id: item.id,
          product_name: product.name,
          requested: item.quantity,
          available: variant.stock_quantity
        }
      end

      issues
    end
  end
end
