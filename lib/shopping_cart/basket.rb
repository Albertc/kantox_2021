# frozen_string_literal: true

module ShoppingCart
  # Base class for the checkout system, it's initilized with the pricing rules
  class Basket
    class InvalidParameterError < StandardError; end

    def initialize(pricing_rules = [])
      @pricing_rules = pricing_rules
      @items = []
      check_pricing_rules!
    end

    # Add a new product to the basket ans increase its quantity
    def scan(product)
      check_product!(product)
      add_product_to_basket(product)
    end

    def total
      sum_items_amounts(items).round(2).to_f
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
      product_price = item.product.price

      item_price = pricing_calculation_class
                     .new(product_price, pricing_rule&.arguments)
                     .total(item.quantity)

      check_price!(item_price)

      item_price
    end

    def pricing_calculation_class_for(pricing_rule)
      PricingCalculationFactory.for(pricing_rule)
    end

    def pricing_rule_for_item(item)
      pricing_rules.find { |promo| promo.arguments[:product] == item.product }
    end

    def check_pricing_rules!
      Validations::PricingRules.check!(pricing_rules)
    end

    def check_product!(product)
      Validations::Products.check!(product)
    end

    def check_price!(item_price)
      Validations::Results.check!(item_price)
    end
  end
end
