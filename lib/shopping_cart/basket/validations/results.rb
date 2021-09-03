# frozen_string_literal: true

module ShoppingCart
  class Basket
    class Validations
      class Results
        class << self
          def check!(total)
            return if valid?(total)

            raise InvalidResultError, total
          end

          private

          def valid?(total)
            return false if total.nil?

            total > 0
          end
        end
      end
    end
  end
end
