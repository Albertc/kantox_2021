# frozen_string_literal: true

RSpec.describe ShoppingCart::Basket do
  let(:tea)        { Product.new(code: 'GR1', name: 'Green tea', price: 3.11) }
  let(:strawberry) { Product.new(code: 'SR1', name: 'Strawberries', price: 5) }
  let(:coffee)     { Product.new(code: 'CF1', name: 'Coffee', price: 11.23) }

  let(:tea_pricing_rule) do
    ShoppingCart::PricingRule.new('pay_fewer_units',
                                  product: tea,
                                  units_to_get: 2,
                                  units_to_pay: 1)
  end
  let(:coffe_pricing_rule) do
    ShoppingCart::PricingRule.new('discount_on_item_price_by_units',
                                  product: coffee,
                                  units: 3,
                                  percent_discount: 33.3)
  end
  let(:strawberry_pricing_rule) do
    ShoppingCart::PricingRule.new('new_price_by_units',
                                  product: strawberry,
                                  units: 3,
                                  price: 4.5)
  end


  describe '#initialize' do
    shared_examples 'initializing_a_basket' do
      it 'initialize the pricing_rules array attribute' do
        expect(subject.instance_variable_get('@pricing_rules'))
          .to eq(expected_pricing_rules)
      end

      it 'initialize the items array attribute' do
        expect(subject.instance_variable_get('@items')).to eq([])
      end
    end

    shared_examples 'raising an invalid pricing rule error' do
      it 'raises an InvalidPricingRuleError' do
        expect { subject }.to raise_error(
          ShoppingCart::Basket::Validations::InvalidPricingRuleError
        )
      end
    end

    context 'when do not receive a parameter' do
      subject { described_class.new }

      let(:expected_pricing_rules) { [] }

      it_behaves_like 'initializing_a_basket'
    end

    context 'when receives a parameter' do
      subject { described_class.new(pricing_rules) }

      context 'when the paramater is not an Array' do
        let(:pricing_rules) { 'not_an_array' }

        it_behaves_like 'raising an invalid pricing rule error'
      end

      context 'when the paramater is an Array' do
        let(:pricing_rules) do
          [tea_pricing_rule, coffe_pricing_rule, strawberry_pricing_rule]
        end
        let(:expected_pricing_rules) { pricing_rules }

        it_behaves_like 'initializing_a_basket'
      end

      context 'when the paramater is an invalid Array' do
        let(:pricing_rules) { [tea_pricing_rule, 'not_a_pricing_rule'] }
        let(:expected_pricing_rules) { pricing_rules }

        it_behaves_like 'raising an invalid pricing rule error'
      end
    end
  end

  describe '#scan' do
    subject { basket.scan(new_product) }

    let(:basket) { described_class.new }

    context 'with an invalid product paramater' do
      let(:new_product) { 'not_a_product' }

      it 'raises an InvalidProductError' do
        expect { subject }.to raise_error(
          ShoppingCart::Basket::Validations::InvalidProductError
        )
      end
    end

    context 'with a valid product paramater' do
      let(:new_product) { tea  }

      shared_examples 'adding a new item in basket' do
        let(:new_item_in_basket) { basket.instance_variable_get('@items').last }

        it 'adds a new item into the array #items' do
          expect { subject }.to(
            change { basket.instance_variable_get('@items').size }.by(1)
          )
        end

        it 'adds a new instance of BasketItem into the array #items' do
          subject

          expect(new_item_in_basket).to be_instance_of(
            ShoppingCart::Basket::BasketItem
          )
        end

        it 'sets valid attributes to the new item' do
          subject

          expect(new_item_in_basket.quantity).to eq(expected_quantity_in_basket)
          expect(new_item_in_basket.product).to eq(expected_new_item_in_basket)
        end
      end

      context 'when the product does not exist in basket' do
        let(:expected_new_item_in_basket) { tea }
        let(:expected_quantity_in_basket) { 1 }

        context 'when the basket is empty' do
          it_behaves_like 'adding a new item in basket'
        end

        context 'when exists other products in basket' do
          before { 2.times { basket.scan(coffee) } }

          it_behaves_like 'adding a new item in basket'
        end
      end

      context 'when the product exists in basket' do
        let(:tea_item_in_basket) do
          basket.instance_variable_get('@items').find do |item|
            item.product == tea
          end
        end

        before do
          basket.scan(coffee)
          basket.scan(tea)
          basket.scan(coffee)
          basket.scan(tea)

          subject
        end

        it 'updates the basket item quantity attribute' do
          expect(tea_item_in_basket.quantity).to eq(3)
        end
      end
    end
  end

  describe '#total' do
    subject { basket.total }

    context 'without pricing rules' do
      let(:basket) { described_class.new }

      before do
        basket.scan(tea)
        basket.scan(coffee)
        basket.scan(strawberry)
        basket.scan(tea)
        basket.scan(strawberry)
        basket.scan(strawberry)
        basket.scan(strawberry)
      end

      it { is_expected.to eq(37.45) }
    end

    context 'with pricing rules' do
      let(:basket) { described_class.new(pricing_rules) }

      context 'with pricing rules from other products' do
        let(:pricing_rules) { [tea_pricing_rule] }

        before do
          basket.scan(coffee)
          basket.scan(coffee)
          basket.scan(strawberry)
        end

        it { is_expected.to eq(27.46) }
      end

      context 'with pricing rules from the products in basket' do
        let(:pricing_rules) do
          [tea_pricing_rule, coffe_pricing_rule, strawberry_pricing_rule]
        end

        context 'when no product reaches the minimum quantity to match a rule'\
          do
          before do
            basket.scan(tea)
            basket.scan(coffee)
            basket.scan(coffee)
            basket.scan(strawberry)
          end

          it { is_expected.to eq(30.57) }
        end

        context 'when one product reaches the minimum quantity to match a rule'\
          do
          before do
            basket.scan(tea)
            basket.scan(tea)
            basket.scan(coffee)
            basket.scan(strawberry)
          end

          it { is_expected.to eq(19.34) }
        end

        context 'when all products reach the minimum quantity to match their '\
                'rules' do
          before do
            basket.scan(tea)
            basket.scan(tea)
            basket.scan(tea)
            basket.scan(coffee)
            basket.scan(coffee)
            basket.scan(coffee)
            basket.scan(strawberry)
            basket.scan(strawberry)
            basket.scan(strawberry)
          end

          it { is_expected.to eq(42.19) }
        end
      end
    end
  end
end
