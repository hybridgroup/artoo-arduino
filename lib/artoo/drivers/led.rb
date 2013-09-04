require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # The LED driver behaviors
    class Led < Driver

      COMMANDS = [:on, :off, :toggle, 
                  :brightness, 
                  :on?, :off?].freeze

      def initialize(params = {})
        @is_on = false
        super
      end

      # @return [Boolean] True if on
      def on?
        @is_on
      end

      # @return [Boolean] True if off
      def off?
        (not on?)
      end

      # Sets led to level HIGH
      def on
        change_state(pin, :high)
        @is_on = true
        true
      end

      # Sets led to level LOW
      def off
        change_state(pin, :low)
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
        connection.pwm_write(pin, level)
      end

      private
      def change_state(pin, level)
        connection.digital_write(pin, level)
      end
    end
  end
end
