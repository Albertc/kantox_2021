# frozen_string_literal: true

RSpec.describe ShoppingCart::AddItemToBasketService do
  describe '#initialize' do
    subject { described_class.new(items, product) }

    context 'with invalid parameters' do
      shared_examples 'raising an invalid parameters error' do
        it do
          expect { subject }.to raise_error(
            ShoppingCart::AddItemToBasketService::InvalidParameterError
          )
        end
      end

      context 'when the product parameter is invalid' do
        let(:items) { [] }
        let(:product) { 'not_a_valid_product' }

        it_behaves_like 'raising an invalid parameters error'
      end

      context 'when the items array parameter is invalid' do
        let(:items) { nil }
        let(:product) { Product.new(code: 'GR1', name: 'Tea', price: 3.11) }

        it_behaves_like 'raising an invalid parameters error'
      end
    end

    context 'with valid parameters' do
      let(:items) { [] }
      let(:product) { Product.new(code: 'Tea', name: 'Tea', price: 3.5) }

      it 'returns an instance of the service with valid attributes' do
        service = subject

        expect(service.instance_variable_get('@items')).to eq items
        expect(service.instance_variable_get('@product')).to eq product
      end
    end
  end

  describe '#call' do
    subject { described_class.new(items, product).call }

    let(:tea) { Product.new(code: 'Tea', name: 'Tea', price: 3.5) }
    let(:coffee) { Product.new(code: 'Coffee', name: 'Coffee', price: 3.5) }
    let(:items) { [tea_basket_item] }
    let(:tea_basket_item) do
      basket_item = ShoppingCart::Basket::BasketItem.new(tea)
      basket_item.quantity = 1

      basket_item
    end

    context 'when the product does not exist in the received items array' do
      let(:product) { coffee }

      it 'change the items array size' do
        expect { subject }.to(change(items, :size).by(1))
      end

      it 'adds in items array a new BasketItem object with valid attributes' do
        subject

        expect(items.last).to be_instance_of(ShoppingCart::Basket::BasketItem)
        expect(items.last.product).to eq(coffee)
        expect(items.last.quantity).to eq(1)
      end
    end

    context 'when the product exists in the received items array' do
      let(:product) { tea }

      it 'does not change items array size' do
        expect { subject }.not_to(change(items, :size))
      end

      it 'increases the quantity of the basket item' do
        expect { subject }.to change(tea_basket_item, :quantity).by(1)
      end
    end
  end
end
