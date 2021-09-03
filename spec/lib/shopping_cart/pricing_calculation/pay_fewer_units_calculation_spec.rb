# frozen_string_literal: true

RSpec.describe ShoppingCart::PricingCalculation::PayFewerUnitsCalculation do
  subject { described_class.new(product.price, arguments).total(quantity) }

  let(:product) { Product.new(code: 'CF1', name: 'Coffee', price: 5) }

  describe '#total' do
    context 'when the quantity is less than the units_to_get of the rule' do
      let(:arguments) { { units_to_get: 4, units_to_pay: 3 } }
      let(:quantity) { 2 }

      it { is_expected.to eq(10) }

      it_behaves_like 'returning a BigDecimal number'
    end

    context 'when units_to_get are more than units_to_pay + 1' do
      let(:arguments) { { units_to_get: 5, units_to_pay: 3 } }
      let(:quantity) { 5 }

      it { is_expected.to eq(15) }

      it_behaves_like 'returning a BigDecimal number'

      context 'when quantity is not multiple of units_to_get' do
        let(:quantity) { 6 }

        it { is_expected.to eq(20) }
      end

      context 'when quantity is more than double of units_to_get' do
        let(:quantity) { 12 }

        it { is_expected.to eq(40) }
      end
    end

    context 'when the units_to_get is 2 and units_to_pay is 1' do
      let(:arguments) { { units_to_get: 2, units_to_pay: 1 } }

      context 'when quantity is 1' do
        let(:quantity) { 1 }

        it { is_expected.to eq(5) }
      end

      context 'when quantity is 2' do
        let(:quantity) { 2 }

        it { is_expected.to eq(5) }
      end

      context 'when quantity is 3' do
        let(:quantity) { 3 }

        it { is_expected.to eq(10) }
      end
    end
  end
end
