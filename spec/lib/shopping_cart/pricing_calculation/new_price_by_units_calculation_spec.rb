# frozen_string_literal: true

RSpec.describe ShoppingCart::PricingCalculation::NewPriceByUnitsCalculation do
  subject { described_class.new(product.price, arguments).total(quantity) }

  let(:arguments) { { price: 10 , units: 3 } }
  let(:product) { Product.new(code: 'CF1', name: 'Coffee', price: 11.23) }

  describe '#total' do
    context 'when the quantity is less than the units of the rule' do
      let(:quantity) { 2 }

      it 'returns the price of the product * quantity' do
        expect(subject).to eq(22.46)
      end

      it_behaves_like 'returning a BigDecimal number'
    end

    context 'when the quantity is equal than the units of the rule' do
      let(:quantity) { 3 }

      it 'returns the price of the rule * quantity' do
        expect(subject).to eq(30)
      end

      it_behaves_like 'returning a BigDecimal number'
    end

    context 'when the quantity is grather than the units of the rule' do
      let(:quantity) { 4 }

      it 'returns the price of the rule * quantity' do
        expect(subject).to eq(40)
      end

      it_behaves_like 'returning a BigDecimal number'
    end
  end
end
