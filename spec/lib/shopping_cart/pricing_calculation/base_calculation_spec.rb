# frozen_string_literal: true

RSpec.describe ShoppingCart::PricingCalculation::BaseCalculation do
  let(:arguments) { { units_to_get: 5, units_to_pay: 4 } }
  let(:product) { Product.new(code: 'GR1', name: 'Green tea', price: 3.11) }

  describe '#initialize' do
    subject { described_class.new(product.price, arguments) }

    it 'sets the attribute "arguments"' do
      expect(subject.instance_variable_get('@arguments')).to eq(
        { units_to_get: 5, units_to_pay: 4 }
      )
    end

    it 'sets the attribute "price" with the product price' do
      expect(subject.instance_variable_get('@price')).to eq(3.11)
    end
  end

  describe '#total' do
    subject { described_class.new(product.price, arguments).total(quantity) }

    let(:quantity) { 7 }

    it 'returns the quantity * price of the product' do
      is_expected.to eq(21.77)
    end
  end
end
