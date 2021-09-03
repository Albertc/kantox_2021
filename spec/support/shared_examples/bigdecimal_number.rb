# frozen_string_literal: true

RSpec.shared_examples 'returning a BigDecimal number' do
  it { expect(subject.class).to eq(BigDecimal) }
end
