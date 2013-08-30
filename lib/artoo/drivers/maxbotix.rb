require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Maxbotix ultrasonic range finder driver behaviors for Firmata
    class Maxbotix < Driver
      COMMANDS = [:range].freeze

      def last_reading
        @last_reading ||= 0.0
      end

      def last_reading=(val)
        @last_reading = val
      end

      # @return [float] last range reading in inches
      def range
        return (( 254.0 / 1024.0 ) * 2.0 * last_reading).to_f
      end

      # @return [float] last range reading in cm
      def range_cm
        return ((last_reading / 2.0) * 2.54).to_f
      end

      # Sets values to read and write from ultrasonic range finder
      # and starts driver
      def start_driver
        connection.set_pin_mode(pin, Firmata::PinModes::ANALOG)
        connection.toggle_pin_reporting(pin)

        every(interval) do
          connection.read_and_process
          handle_events
        end

        super
      end

      def handle_events
        while i = find_event("analog_read_#{pin}") do
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

      # Publishes events according to the ultrasonic rangefinder value
      def update(value)
        last_reading = value
        publish(event_topic_name("update"), "range", range)
        publish(event_topic_name("range"), range)
      end
    end
  end
end
