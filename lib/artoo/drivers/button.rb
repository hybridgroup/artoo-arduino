require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Button driver behaviors
    class Button < Driver
      COMMANDS = [:is_pressed?].freeze

      DOWN = 1
      UP = 0

      # @return [Boolean] True if pressed
      def is_pressed?
        (@pressed_val == 1) ? true : false
      end

      def start_driver
        @pressed_val = 0

        every(interval) do
          new_value = connection.digital_read(pin)
          update(new_value) if !new_value.nil? && new_value != is_pressed?
        end

        super
      end

      private
      # Publishes events according to the button feedback
      def update(new_val)
        if new_val == 1
          @pressed_val = 1
          publish(event_topic_name("update"), "push", new_val)
          publish(event_topic_name("push"), new_val)
        else
          @pressed_val = 0
          publish(event_topic_name("update"), "release", new_val)
          publish(event_topic_name("release"), new_val)
        end
      end
    end
  end
end
