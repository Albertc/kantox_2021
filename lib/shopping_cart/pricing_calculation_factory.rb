# frozen_string_literal: true

module ShoppingCart
  # Factory to choose the PricingCalculation class according each pricing rule
  class PricingCalculationFactory
    class InvalidPricingRuleError < StandardError; end

    def self.for(pricing_rule)
      return PricingCalculation::BaseCalculation unless pricing_rule

      case pricing_rule.name
      when 'discount_on_item_price_by_units'
        PricingCalculation::DiscountOnItemPriceByUnitsCalculation
      when 'new_price_by_units'
        PricingCalculation::NewPriceByUnitsCalculation
      when 'pay_fewer_units'
        PricingCalculation::PayFewerUnitsCalculation
      else
        raise InvalidPricingRuleError, pricing_rule.name
      end
    end
  end
end
