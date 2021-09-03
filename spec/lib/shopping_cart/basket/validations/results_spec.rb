# frozen_string_literal: true

RSpec.describe ShoppingCart::Basket::Validations::Results do
  describe '#check' do
    subject { described_class.check!(total) }

    shared_examples 'raising an error' do
      it 'raises an InvalidPricingRuleError' do
        expect { subject }.to raise_error(
          ShoppingCart::Basket::Validations::InvalidResultError
        )
      end
    end

    context 'when the total is nil' do
      let(:total) { nil }

      it_behaves_like 'raising an error'
    end

    context 'when the total is 0' do
      let(:total) { 0 }

      it_behaves_like 'raising an error'
    end

    context 'when the total is less than 0' do
      let(:total) { -1 }

      it_behaves_like 'raising an error'
    end

    context 'when the total is positive' do
      let(:total) { 23.12 }

      it { is_expected.to be_nil }
    end
  end
end
