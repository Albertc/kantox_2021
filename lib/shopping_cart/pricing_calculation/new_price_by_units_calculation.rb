# frozen_string_literal: true

require_relative 'base_calculation'

module ShoppingCart
  class PricingCalculation
    class NewPriceByUnitsCalculation < BaseCalculation
      def total(quantity)
        self.price = new_price if quantity >= units_of_the_rule

        super(quantity)
      end

      private

      def new_price
        parse_decimals(self.arguments[:price])
      end

      def units_of_the_rule
        self.arguments[:units]
      end
    end
  end
end
