require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Maxbotix ultrasonic range finder driver behaviors for Firmata
    class Maxbotix < Driver
      COMMANDS = [:range].freeze

      attr_accessor :last_reading

      def initialize(params={})
        @last_reading = 0.0
        super
      end

      # @return [float] last range reading in inches
      def range
        return ( 254.0 / 1024.0 ) * 2.0 * last_reading
      end

      # @return [float] last range reading in cm
      def range_cm
        return (last_reading / 2.0) * 2.54
      end

      # Sets values to read from ultrasonic range finder
      # and starts driver
      def start_driver
        every(interval) do
          update(connection.analog_read(pin))
        end

        super
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
