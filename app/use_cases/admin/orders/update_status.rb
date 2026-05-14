module Admin
  module Orders
    class UpdateStatus < BaseUseCase
      TRANSITIONS = {
        ::Order::PAID => [ ::Order::SHIPPED, ::Order::CANCELLED ],
        ::Order::SHIPPED => [ ::Order::DELIVERED, ::Order::CANCELLED ],
        ::Order::PENDING => [ ::Order::CANCELLED ]
      }.freeze

      class InvalidTransition < StandardError; end

      def initialize(order:, new_status:)
        @order = order
        @new_status = new_status
      end

      private

      def call
        validate_transition!
        @order.update!(status: @new_status)
        @order
      end

      def validate_transition!
        allowed = TRANSITIONS[@order.status] || []
        return if allowed.include?(@new_status)

        raise InvalidTransition,
              "Cannot transition from #{@order.status} to #{@new_status}"
      end
    end
  end
end
