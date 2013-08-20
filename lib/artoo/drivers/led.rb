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
        catch(:pin_state_response) do
          query_pin_state_on_board
          loop do
            handle_pin_state_event
          end
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
        change_state(pin, Firmata::PinLevels::HIGH)
        @is_on = true
        true
      end

      # Sets led to level LOW
      def off
        change_state(pin, Firmata::PinLevels::LOW)
        @is_on = false
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

      def handle_pin_state_event
        events = connection.async_events
        event_index = events.index { |e| e.name == "pin_#{pin}_state".to_sym }
        if event_index
          @is_on = (not events.slice!(event_index).data.first.zero?)
          throw :pin_state_response
        end
      end

      def change_state(pin, level)
        connection.set_pin_mode(pin, Firmata::PinModes::OUTPUT)
        connection.digital_write(pin, level)
      end
    end
  end
end
