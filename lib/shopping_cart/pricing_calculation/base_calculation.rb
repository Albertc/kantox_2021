# frozen_string_literal: true

require 'bigdecimal'

module ShoppingCart
  class PricingCalculation
    class BaseCalculation
      def initialize(price, arguments)
        @price = parse_decimals(price)
        @arguments = arguments
      end

      def total(quantity)
        quantity * price
      end

      protected

      attr_reader :arguments
      attr_accessor :price

      def parse_decimals(number)
        BigDecimal(number.to_s)
      end
    end
  end
end
