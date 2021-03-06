require 'spec_helper'

describe ChefSpec::Matchers::IncludeRecipeMatcher do
  let(:chef_run) { double('chef run', run_context: { loaded_recipes: %w(one two three) }) }
  subject { described_class.new('one::default') }

  describe '#failure_message_for_should' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.failure_message_for_should)
        .to eq(%q(expected ["one::default", "two::default", "three::default"] to include 'one::default'))
    end
  end

  describe '#failure_message_for_should_not' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.failure_message_for_should_not)
        .to eq(%q(expected 'one::default' to not be included))
    end
  end

  describe '#description' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.description).to eq(%q(include recipe 'one::default'))
    end
  end

  it 'matches when the recipe is included' do
    expect(subject.matches?(chef_run)).to be_true
  end

  it 'does not match when the recipe is not included' do
    failure = described_class.new('nope')
    expect(failure.matches?(chef_run)).to be_false
  end
end
