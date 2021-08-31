# frozen_string_literal: true

RSpec.describe Product do
  describe '#initialize' do
    subject { described_class.new(code: '001', name: 'Tea', price: 1.23) }

    it 'initialize valid attributes' do
      tea = subject

      expect(tea.code).to eq('001')
      expect(tea.name).to eq('Tea')
      expect(tea.price).to eq(1.23)
    end
  end
end

