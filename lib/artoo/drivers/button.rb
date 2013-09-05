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
        (@is_pressed ||= false) == true
      end

      def start_driver
        @is_pressed = false

        every(interval) do
          new_value = connection.digital_read(pin)
          update(new_value) if new_value != @is_pressed
        end

        super
      end

      # Publishes events according to the button feedback
      def update(pressed)
        if pressed
          @is_pressed = true
          publish(event_topic_name("update"), "push", pressed)
          publish(event_topic_name("push"), pressed)
        else
          @is_pressed = false
          publish(event_topic_name("update"), "release", pressed)
          publish(event_topic_name("release"), pressed)
        end
      end
    end
  end
end
