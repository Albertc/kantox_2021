# frozen_string_literal: true

module ShoppingCart
  class Basket
    class Validations
      class Products
        def self.check!(product)
          return if product.is_a?(Product)

          raise InvalidProductError
        end
      end
    end
  end
end
