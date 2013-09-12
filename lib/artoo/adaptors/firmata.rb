require 'artoo/adaptors/adaptor'

module Artoo
  module Adaptors
    # Connect to Arduino using Firmata
    # @see http://rubydoc.info/gems/hybridgroup-firmata/0.3.0/Firmata/Board HybridGroup Firmata Documentation
    class Firmata < Adaptor
      attr_reader :firmata

      # Creates connection with firmata board
      # @return [Boolean]
      def connect
        require 'firmata' unless defined?(::Firmata::Board)
        
        @firmata = ::Firmata::Board.new(connect_to)
        @firmata.connect
        super
        return true
      end

      # Closes connection with firmata board
      # @return [Boolean]
      def disconnect
        super
      end

      # GPIO - digital
      def digital_write(pin, level)
        firmata.set_pin_mode(pin, ::Firmata::PinModes::OUTPUT)
        firmata.digital_write(pin, convert_level(level))
      end

      def digital_read(pin)
        firmata.set_pin_mode(pin, ::Firmata::PinModes::INPUT)
        firmata.toggle_pin_reporting(pin)
        firmata.read_and_process

        value = nil
        while i = find_event("digital_read_#{pin}")
          event = events.slice!(i)
          value = event.data.first if !event.nil?
        end
        value
      end
      
      # GPIO - analog
      # NOTE pins are numbered A0-A5, which translate to digital pins 14-19
      def analog_read(pin)
        firmata.set_pin_mode(digital_pin(pin), ::Firmata::PinModes::ANALOG)
        firmata.toggle_pin_reporting(digital_pin(pin))
        firmata.read_and_process

        value = 0
        while i = find_event("analog_read_#{pin}") do
          event = events.slice!(i)
          value = event.data.first if !event.nil?
        end
        value
      end

      def digital_pin(pin = 0)
        pin + 14
      end

      # GPIO - PWM
      def pwm_write(pin, level)
        firmata.set_pin_mode(pin, ::Firmata::PinModes::PWM)
        firmata.analog_write(pin, level)
      end

      # GPIO - servo
      def servo_write(pin, angle)
        firmata.set_pin_mode(pin, ::Firmata::PinModes::SERVO)
        firmata.analog_write(pin, angle)
      end

      # i2c interface
      def i2c_start(address)
        @i2c_address = address

        firmata.i2c_config(0)
      end

      def i2c_end
        
      end

      def i2c_read(size)
        firmata.i2c_read_request(@i2c_address, size)
        firmata.read_and_process

        value = []
        while i = find_event(:i2c_reply) do
          event = events.slice!(i)
          value = event.data.first[:data] if !event.nil?
        end
        value
      end

      def i2c_write(*data)
        firmata.i2c_write_request(@i2c_address, data)
      end

      # helpers
      def find_event(name)
        events.index {|e| e.name == name.to_sym }
      end

      def events
        firmata.async_events
      end

      # Uses method missing to call Firmata Board methods
      # @see http://rubydoc.info/gems/hybridgroup-firmata/0.3.0/Firmata/Board Firmata Board Documentation
      def method_missing(method_name, *arguments, &block)
        firmata.send(method_name, *arguments, &block)
      end

    protected
      def convert_level(level)
        case level
        when :low
          ::Firmata::PinLevels::LOW
        when :high
          ::Firmata::PinLevels::HIGH
        end
      end
    end
  end
end
