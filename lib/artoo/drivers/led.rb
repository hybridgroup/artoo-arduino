require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The LED driver behaviors
    class Led < Driver

      COMMANDS = [:firmware_name, :version,
                  :on, :off, :toggle, 
                  :brightness, 
                  :on?, :off?].freeze

      def start_driver
        every(interval) do
          connection.read_and_process
          handle_events
        end
        super
      end

      # @return [Boolean] True if on
      def on?
        @is_on
      end

      # @return [Boolean] True if off
      def off?
        not on?
      end

      # Sets led to level HIGH
      def on
        if !on?
          change_state(pin, Firmata::PinLevels::HIGH)
          query_pin_state_on_board
        end
        true
      end

      # Sets led to level LOW
      def off
        if !off?
          change_state(pin, Firmata::PinLevels::LOW)
          query_pin_state_on_board
        end
        true
      end

      # Toggle status
      # @example on > off, off > on
      def toggle
        on? ? off : on
      end

      # Change brightness level
      # @param [Integer] level
      def brightness(level=0)
        connection.set_pin_mode(pin, Firmata::PinModes::PWM)
        connection.analog_write(pin, level)
      end

      private
      def query_pin_state_on_board
        connection.query_pin_state(pin)
      end

      def handle_events
        events = connection.async_events
        while i = events.index { |e| e.name == "pin_#{pin}_state".to_sym} do
          event = (events.slice!(i))
          @is_on = (!event.data.first.zero?) if !event.nil?
        end
      end

      def change_state(pin, level)
        connection.set_pin_mode(pin, Firmata::PinModes::OUTPUT)
        connection.digital_write(pin, level)
      end
    end
  end
end
