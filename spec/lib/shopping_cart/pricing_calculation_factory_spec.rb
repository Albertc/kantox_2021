# frozen_string_literal: true

RSpec.describe ShoppingCart::PricingCalculationFactory do
  describe '#for' do
    subject { described_class.for(pricing_rule) }

    let(:product) { Product.new(code: 'C01', name: 'Coffee', price: 2.5) }
    let(:pricing_rule) do
      ShoppingCart::PricingRule.new(
        pricing_rule_name, product: product, whatever: 1
      )
    end

    context 'when the name of the pricing_rule is '\
            'discount_on_item_price_by_units' do
      let(:pricing_rule_name) { 'discount_on_item_price_by_units' }

      it 'returns the valid class' do
        expect(subject).to eq(
          ShoppingCart::
            PricingCalculation::
            DiscountOnItemPriceByUnitsCalculation
        )
      end
    end

    context 'when the name of the pricing_rule is new_price_by_units' do
      let(:pricing_rule_name) { 'new_price_by_units' }

      it 'returns the valid class' do
        expect(subject).to eq(
          ShoppingCart::PricingCalculation::NewPriceByUnitsCalculation
        )
      end
    end

    context 'when the name of the pricing_rule is "pay_fewer_units' do
      let(:pricing_rule_name) { 'pay_fewer_units' }

      it 'returns the valid class' do
        expect(subject).to eq(
          ShoppingCart::PricingCalculation::PayFewerUnitsCalculation
        )
      end
    end

    context 'when the name of the pricing_rule is not recognized' do
      let(:pricing_rule_name) { 'wrong_name' }

      it 'raises an error' do
        expect { subject }.to raise_error(
          ShoppingCart::PricingCalculationFactory::InvalidPricingRuleError
        ).with_message('wrong_name')
      end
    end
  end
end
