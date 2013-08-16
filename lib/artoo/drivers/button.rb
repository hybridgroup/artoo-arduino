require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Button driver behaviors for Firmata
    class Button < Driver
      COMMANDS = [:is_pressed?].freeze

      DOWN = 1
      UP = 0

      # @return [Boolean] True if pressed
      def is_pressed?
        (@is_pressed ||= false) == true
      end

      # Sets values to read and write from button
      # and starts driver
      def start_driver
        connection.set_pin_mode(pin, Firmata::PinModes::INPUT)
        connection.toggle_pin_reporting(pin)

        every(interval) do
          handle_events
        end

        super
      end

      def handle_events
        while i = find_event("digital_read_#{pin}") do
          event = events.slice!(i)
          update(event.data.first) if !event.nil?
        end
      end

      def find_event(name)
        events.index {|e| e.name == name.to_sym}
      end

      def events
        connection.async_events
      end

      # Publishes events according to the button feedback
      def update(value)
        if value == DOWN
          @is_pressed = true
          publish(event_topic_name("update"), "push", value)
          publish(event_topic_name("push"), value)
        else
          @is_pressed = false
          publish(event_topic_name("update"), "release", value)
          publish(event_topic_name("release"), value)
        end
      end
    end
  end
end
