# frozen_string_literal: true

require_relative 'base_calculation'

module ShoppingCart
  class PricingCalculation
    # Rule for "Pay 3 and get 1 free" (for instance)
    #   If the quantity in basket is 4 will pay 3
    #   units_to_get: 4, units_to_pay: 3
    class PayFewerUnitsCalculation < BaseCalculation
      def total(quantity)
        quantity = new_quantity(quantity) if quantity >= units_to_get

        super(quantity)
      end

      private

      def new_quantity(quantity)
        (quantity * (units_to_pay.to_f / units_to_get.to_f)).ceil
      end

      def units_to_get
        arguments[:units_to_get]
      end

      def units_to_pay
        arguments[:units_to_pay]
      end
    end
  end
end
