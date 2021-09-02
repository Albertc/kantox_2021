# frozen_string_literal: true

require_relative '../../../app/models/product'

module ShoppingCart
  # Search <product> in array <items> and if it doesn't exist, will create it
  # and add to the <items> array
  class AddItemToBasketService
    class InvalidParameterError < StandardError; end

    def initialize(items, product)
      @items = items
      @product = product

      raise InvalidParameterError unless valid_parameters?
    end

    def call
      item = find_or_create_product_in_basket
      item.quantity += 1
    end

    private

    attr_accessor :items
    attr_reader :product

    def find_or_create_product_in_basket
      unless (item = find_item)
        item = Basket::BasketItem.new(product)
        items << item
      end

      item
    end

    def find_item
      items.find { |basket_item| basket_item.product.code == product.code }
    end

    def valid_parameters?
      items.is_a?(Array) && product.is_a?(Product)
    end
  end
end
