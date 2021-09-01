# frozen_string_literal: true

RSpec.describe ShoppingCart::Basket::BasketItem do
  describe '#initialize' do
    subject { described_class.new(product) }

    let(:product) { Product.new(code: '001', name: 'FPP3 mask', price: 9.5) }

    it 'sets the product attribute with the parameter' do
      expect(subject.product).to eq(product)
    end

    it 'sets the quantity attribute with 0' do
      expect(subject.quantity).to eq(0)
    end
  end
end
