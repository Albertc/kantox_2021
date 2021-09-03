# frozen_string_literal: true

module ShoppingCart
  class Basket
    class Validations
      class InvalidPricingRuleError < StandardError; end
      class InvalidProductError < StandardError; end
      class InvalidResultError < StandardError; end
    end
  end
end
