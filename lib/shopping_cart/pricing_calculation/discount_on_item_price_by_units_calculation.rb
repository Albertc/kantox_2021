# frozen_string_literal: true

require_relative 'base_calculation'

module ShoppingCart
  class PricingCalculation
    class DiscountOnItemPriceByUnitsCalculation < BaseCalculation
      def total(quantity)
        self.price -= discount if quantity >= units_of_the_rule

        super(quantity)
      end

      private

      def discount
        (self.price * self.arguments[:percent_discount] / 100)
      end

      def units_of_the_rule
         self.arguments[:units]
      end
    end
  end
end
