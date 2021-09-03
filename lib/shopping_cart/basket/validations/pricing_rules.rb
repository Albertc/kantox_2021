# frozen_string_literal: true

module ShoppingCart
  class Basket
    class Validations
      class PricingRules
        class << self
          def check!(pricing_rules)
            return if valid?(pricing_rules)

            raise InvalidPricingRuleError
          end

          private

          def valid?(pricing_rules)
            return false unless pricing_rules.is_a?(Array)
            return true if pricing_rules.empty?

            pricing_rules.all? { |promo| promo.is_a?(ShoppingCart::PricingRule) }
          end
        end
      end
    end
  end
end
