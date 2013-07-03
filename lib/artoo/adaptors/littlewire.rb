require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to Digispark or Littlewire device using Littlewire protocol
    # @see http://littlewire.cc/
    class LittleWire < Adaptor
      attr_reader :littlewire

      # Creates connection with littlewire board
      # @return [Boolean]
      def connect
        require 'littlewire' unless defined?(::LittleWire)
        @littlewire = ::LittleWire.new(connect_to)
        super
        return true
      end

      # Closes connection with littlewire board
      # @return [Boolean]
      def disconnect
        @littlewire.finished
        super
      end

      # Uses method missing to call Littlewire methods
      # @see https://github.com/Bluebie/littlewire.rb
      def method_missing(method_name, *arguments, &block)
        littlewire.send(method_name, *arguments, &block)
      end
    end
  end
end
