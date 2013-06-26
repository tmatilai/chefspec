module ChefSpec
  module Matchers

    RSpec::Matchers.define :set_node do
      UNSET_VALUE = Object.new unless defined? UNSET_VALUE

      @attributes = []
      @actual     = UNSET_VALUE
      @expected   = UNSET_VALUE

      match do |chef_runner|
        @actual = find_node_attribute(chef_runner.node)
        !set?(@expected) || @actual == @expected
      end

      chain :[] do |attribute|
        @attributes << attribute.to_s
      end

      chain :to do |value|
        @expected = value
      end

      failure_message_for_should { failure_message }
      failure_message_for_should_not { failure_message(:negative => true) }

      def set?(value)
        value != UNSET_VALUE
      end

      # Return the value of the node attribute specified by attributes list
      #
      # @raise [RSpec::Expectations::ExpectationNotMetError] if the node attribute is not set
      def find_node_attribute(node)
        raise "No node attributes specified" if @attributes.empty?

        @attributes.inject(node) do |value, key|
          raise RSpec::Expectations::ExpectationNotMetError unless value.key?(key)
          value[key]
        end
      end

      def failure_message(opts = {})
        msg = "expected node#{node_attributes} #{'not ' if opts[:negative]}to be set"
        if set?(@expected)
          msg << " to #{@expected.inspect}"
          msg << "\n     got: #{@actual.inspect}" unless opts[:negative]
        else
          msg << "\n     got: #{@actual.inspect}" if opts[:negative]
        end
        msg
      end

      def node_attributes
        @attributes.map { |attr| "['#{attr}']" }.join
      end
    end

  end
end
