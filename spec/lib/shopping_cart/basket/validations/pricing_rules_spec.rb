# frozen_string_literal: true

RSpec.describe ShoppingCart::Basket::Validations::PricingRules do
  describe '#check' do
    subject { described_class.check!(pricing_rules) }

    shared_examples 'raising an error' do
      it 'raises an InvalidPricingRuleError' do
        expect { subject }.to raise_error(
          ShoppingCart::Basket::Validations::InvalidPricingRuleError
        )
      end
    end

    context 'when the paremter is nil' do
      let(:pricing_rules) { nil }

      it_behaves_like 'raising an error'
    end

    context 'when the paremter does not contain an array' do
      let(:pricing_rules) { 'not_an_array' }

      it_behaves_like 'raising an error'
    end

    context 'when the paremter is an array without instances of PricingRule class' do
      let(:pricing_rules) do
        [ ShoppingCart::PricingRule.new('promo', {}), 'not_a_pricing_rule']
      end

      it_behaves_like 'raising an error'
    end

    context 'when the paremter contain a valid array of PricingRule instances' do
      let(:pricing_rules) { [ ShoppingCart::PricingRule.new('promo', {})] }

      it { is_expected.to be_nil }
    end
  end
end
