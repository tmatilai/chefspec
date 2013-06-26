require 'spec_helper'

module ChefSpec
  module Matchers
    describe :set_node do

      context "with expected value" do
        let(:matcher) { set_node['foo']['bar'].to 'baz' }

        it "should match if the attribute is set and matches" do
          matcher.matches?({:node => {'foo' => {'bar' => 'baz'}}}).should be true
        end
        it "should not match if the attribute is set but differs" do
          matcher.matches?({:node => {'foo' => {'bar' => 'moe'}}}).should be false
        end
        it "should not match if the attribute is not set" do
          matcher.matches?({:node => {'foo' => {}}}).should be false
        end
        it "should not match if the first level attribute is not set" do
          matcher.matches?({:node => {}}).should be false
        end
      end

      context "without expected" do
        let(:matcher) { set_node['foo']['bar'] }

        it "should match if the attribute is set" do
          matcher.matches?({:node => {'foo' => {'bar' => 'baz'}}}).should be true
        end
        it "should match if the attribute is set to nil" do
          matcher.matches?({:node => {'foo' => {'bar' => nil}}}).should be true
        end
        it "should not match if the attribute is not set" do
          matcher.matches?({:node => {'foo' => {}}}).should be false
        end
        it "should not match if the first level attribute is not set" do
          matcher.matches?({:node => {}}).should be false
        end
      end

      context "without attributes" do
        let(:matcher) { set_node }

        it "should raise error" do
          expect { matcher.matches?({:node => {}}) }.to raise_error
        end
      end

    end
  end
end
