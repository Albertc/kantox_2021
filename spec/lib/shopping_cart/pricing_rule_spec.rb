# frozen_string_literal: true

RSpec.describe ShoppingCart::PricingRule do
  describe '#new' do
    subject(:promotional_rule) { described_class.new(name, arguments) }

    let(:product) { Product.new(code: 'GR1', name: 'Green tea', price: 3.11) }
    let(:arguments) { { product: product, price: 8.25, quantity: 5 } }
    let(:name) { 'discount_test_name' }

    it 'sets valid attributes from params provided' do
      expect(promotional_rule.name).to eq(name)
      expect(promotional_rule.arguments).to eq(arguments)
    end
  end
end
