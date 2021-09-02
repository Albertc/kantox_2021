# frozen_string_literal: true

module ShoppingCart
  # Base class for the checkout system, it's initilized with the pricing rules
  class Basket
    class InvalidParameterError < StandardError; end

    def initialize(pricing_rules = [])
      @pricing_rules = pricing_rules
      @items = []

      raise InvalidParameterError unless valid_pricing_rules_parameters?
    end

    # Add a new product to the basket ans increase its quantity
    def scan(product)
      raise InvalidParameterError unless valid_product_parameter?(product)

      add_product_to_basket(product)
    end

    def total
      sum_items_amounts(items)
    end

    private

    attr_accessor :items
    attr_reader :pricing_rules

    def add_product_to_basket(product)
      AddItemToBasketService.new(items, product).call
    end

    def sum_items_amounts(items)
      items.inject(0) { |sum, item| sum + price_for(item) }
    end

    def price_for(item)
      pricing_rule = pricing_rule_for_item(item)
      pricing_calculation_class = pricing_calculation_class_for(pricing_rule)
      item_price = item.product.price

      pricing_calculation_class
        .new(item_price, pricing_rule&.arguments)
        .total(item.quantity)
    end

    def pricing_calculation_class_for(pricing_rule)
      PricingCalculationFactory.for(pricing_rule)
    end

    def pricing_rule_for_item(item)
      pricing_rules.find { |promo| promo.arguments[:product] == item.product }
    end

    def valid_pricing_rules_parameters?
      return false unless pricing_rules.is_a?(Array)
      return true if pricing_rules.empty?

      pricing_rules.all? { |promo| promo.is_a?(ShoppingCart::PricingRule) }
    end

    def valid_product_parameter?(product)
      product.is_a?(Product)
    end
  end
end
