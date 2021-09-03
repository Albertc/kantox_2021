# frozen_string_literal: true

RSpec.describe ShoppingCart::Basket::Validations::Products do
  describe '#check' do
    subject { described_class.check!(product) }

    shared_examples 'raising an error' do
      it 'raises an InvalidPricingRuleError' do
        expect { subject }.to raise_error(
          ShoppingCart::Basket::Validations::InvalidProductError
        )
      end
    end

    context 'when the parameter is nil' do
      let(:product) { nil }

      it_behaves_like 'raising an error'
    end

    context 'when the parameter is not a product' do
      let(:product) { 'not_a_product' }

      it_behaves_like 'raising an error'
    end

    context 'when the parameter is a product' do
      let(:product) { Product.new }

      it { is_expected.to be_nil }
    end
  end
end
