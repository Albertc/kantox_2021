# frozen_string_literal: true

module ShoppingCart
  class Basket
    # Item of a basket, it consists of a product and a quantity.
    # every time new product is added to the checkout system, a BasketItem
    # object is created (if not exists) and the quantity is increased
    class BasketItem
      attr_accessor :quantity
      attr_reader :product

      def initialize(product)
        @product = product
        @quantity = 0
      end
    end
  end
end
