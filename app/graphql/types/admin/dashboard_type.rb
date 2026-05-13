module Types
  module Admin
    class DashboardType < Types::BaseObject
      graphql_name "AdminDashboard"

      field :order_counts_by_status, [Types::Admin::StatusCountType], null: false
      field :product_counts_by_status, [Types::Admin::StatusCountType], null: false
      field :revenue_today_cents, Integer, null: false
      field :revenue_this_week_cents, Integer, null: false
      field :revenue_this_month_cents, Integer, null: false
      field :recent_orders, [Types::OrderType], null: false
      field :low_stock_variants, [Types::Admin::LowStockVariantType], null: false

      def order_counts_by_status
        object[:order_counts_by_status].map { |status, count| { status:, count: } }
      end

      def product_counts_by_status
        object[:product_counts_by_status].map { |status, count| { status:, count: } }
      end
    end
  end
end
