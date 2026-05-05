module Types
  module Order
    class StatusEnum < Types::BaseEnum
      graphql_name "OrderStatus"
      description "Status of an order"

      value "PENDING", "Order created, awaiting payment", value: ::Order::PENDING
      value "PAID", "Payment confirmed", value: ::Order::PAID
      value "SHIPPED", "Order has been shipped", value: ::Order::SHIPPED
      value "DELIVERED", "Order has been delivered", value: ::Order::DELIVERED
      value "CANCELLED", "Order has been cancelled", value: ::Order::CANCELLED
    end
  end
end
