# frozen_string_literal: true

module ShoppingCart
  # Class to define which rules will apply the Basket to calculate the amounts.
  # Init parameters:
  #  <name#string> name of the rule
  #  <arguments#hash> arguments needed for the rule calculation
  class PricingRule
    attr_reader :name, :arguments

    def initialize(name, **arguments)
      @name = name
      @arguments = arguments
    end
  end
end
