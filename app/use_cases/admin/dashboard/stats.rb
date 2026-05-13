module Admin
  module Dashboard
    class Stats < BaseUseCase
      LOW_STOCK_THRESHOLD = 5

      def initialize
        # No arguments needed — aggregates global data
      end

      private

      def call
        {
          order_counts_by_status:,
          product_counts_by_status:,
          revenue_today_cents:,
          revenue_this_week_cents:,
          revenue_this_month_cents:,
          recent_orders:,
          low_stock_variants:
        }
      end

      def order_counts_by_status
        Order.group(:status).count
      end

      def product_counts_by_status
        Product.group(:status).count
      end

      def revenue_today_cents
        paid_orders_since(Time.current.beginning_of_day).sum(:total_cents)
      end

      def revenue_this_week_cents
        paid_orders_since(Time.current.beginning_of_week).sum(:total_cents)
      end

      def revenue_this_month_cents
        paid_orders_since(Time.current.beginning_of_month).sum(:total_cents)
      end

      def recent_orders
        Order.order(created_at: :desc).limit(10).includes(:line_items)
      end

      def low_stock_variants
        ProductVariant
          .joins(:product)
          .where(products: { status: Product::ACTIVE })
          .where("product_variants.stock_quantity < ?", LOW_STOCK_THRESHOLD)
          .includes(:product)
          .order(:stock_quantity)
      end

      def paid_orders_since(start_time)
        Order.where(status: [Order::PAID, Order::SHIPPED, Order::DELIVERED])
             .where("created_at >= ?", start_time)
      end
    end
  end
end
