# frozen_string_literal: true

module ShoppingCart
  class PricingCalculation
    class BaseCalculation
      def initialize(price, arguments)
        @price = price
        @arguments = arguments
      end

      def total(quantity)
        (quantity * price)
      end

      protected

      attr_reader :arguments
      attr_accessor :price
    end
  end
end
