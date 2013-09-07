require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to Digispark or Littlewire device using Little Wire protocol
    # @see http://littlewire.cc/
    class Littlewire < Adaptor
      attr_reader :littlewire, :vendor, :product, :usb

      def initialize(params={})
        super

        params[:additional_params] ||= {}
        @vendor = params[:additional_params][:vendor] || 0x1781
        @product = params[:additional_params][:product] || 0x0c9f
      end

      # Creates connection with littlewire board
      # @return [Boolean]
      def connect
        require 'littlewire' unless defined?(::LittleWire)
        @littlewire = ::LittleWire.new(connect_to_usb)
        super
        return true
      end

      # Closes connection with littlewire board
      # @return [Boolean]
      def disconnect
        littlewire.finished
        super
      end

      # Returns firmware name of littlewire board
      # @return [String]
      def firmware_name
        "Little Wire"
      end

      def digital_read(pin)
        littlewire.digital_write(pin, true)
        littlewire.digital_read(pin)
      end

      def pwm_write(pin, level)
        littlewire.software_pwm_write(pin, level)
      end

      def connect_to_usb
        @usb = LIBUSB::Context.new.devices(
          :idVendor  => vendor,
          :idProduct => product
        ).first
      end

      # Uses method missing to call Littlewire methods
      # @see https://github.com/Bluebie/littlewire.rb
      def method_missing(method_name, *arguments, &block)
        littlewire.send(method_name, *arguments, &block)
      end
    end
  end
end
