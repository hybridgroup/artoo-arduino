require 'artoo/drivers/driver'

module Artoo
  module Drivers
    class Motor < Driver

      COMMANDS = [:stop, :start, :on?, :off?]

      attr_reader :speed_pin, :switch_pin, :current_speed

      # Create new Motor
      def initialize(params={})
        super
        
        additional_params = params[:additional_params]
        @speed_pin = additional_params[:speed_pin]
        @speed_pin = additional_params[:switch_pin] if additional_params[:switch_pin]

        @forward_pin = additional_params[:forward_pin]
        @backward_pin = additional_params[:backward_pin]

        @forward_pins = additional_params[:forward_pins]
        @backward_pins = additional_params[:backward_pins]

        @direction_pin = additional_params[:direction_pin]

        @current_state = 0
        @current_speed = 0

        @current_mode = :digital # just to switch the motor on or off, no speed control

        @@modules_to_include =
        if @speed_pin and @forward_pins and @backward_pins

        elsif @speed_pin and @forward_pin and @backward_pin
          [Unidirectional, BidirectionalWith2Pins]
        elsif @forward_pins and @backward_pins

        elsif @forward_pin and @backward_pin
          [Unidirectional, BidirectionalWith2Pins]
        elsif @speed_pin and @direction_pin

        elsif @direction_pin

        elsif @speed_pin
          [Unidirectional]
        end

        class << self
          include Common
          @@modules_to_include.each do |m|
            include m
          end
        end

      end

      # Starts connection to read and process and driver
      def start_driver
        every(interval) do
          connection.read_and_process
        end

        super
      end

    end

    module Common
      def self.included(mod)
      end
    end

    module Unidirectional

      def self.included(mod)
        mod::COMMANDS.push(*[:toggle, :speed, :min, :max, :current_speed])
      end

      def stop
        if digital?
          change_state(Firmata::PinLevels::LOW)
        else
          speed(0)
        end
      end

      def start
        if digital?
          change_state(Firmata::PinLevels::HIGH)
        else
          speed(255)
        end
      end

      def min
        stop
      end

      def max
        start
      end

      def on?
        if digital?
          @current_state == Firmata::PinLevels::HIGH
        else
          @current_speed > 0
        end
      end

      def off?
        !on?
      end

      def toggle
        on? ? stop : start
      end

      def change_state(state)
        @current_state = state
        @current_speed = state.zero? ? 0 : 255
        connection.set_pin_mode(@speed_pin, Firmata::PinModes::OUTPUT)
        connection.digital_write(@speed_pin, state)
      end

      # Set motor speed
      # @param [Integer] value (must be an integer between 0-255)
      def speed(value)
        @current_mode = :analog
        raise "Motor speed must be an integer between 0-255" unless (value.is_a?(Numeric) && value >= 0 && value <= 255)
        @current_speed = value
        connection.set_pin_mode(speed_pin, ::Firmata::PinModes::PWM)
        connection.analog_write(speed_pin, value)
      end

      def digital?
        @current_mode == :digital
      end

      def analog?
        @current_mode == :analog
      end
    end

    module BidirectionalWith1Pin
    
    end

    module BidirectionalWith2Pins

      def self.included(mod)
        mod::COMMANDS.push(*[:forward, :backward])
      end

      # Sets movement forward
      # @param [Integer] speed
      def forward
        direction(:forward)
        #speed ? self.speed(speed) : self.speed(255)
      end

      # Sets movement backward
      # @param [Integer] speed
      def backward
        direction(:backward)
        #speed ? self.speed(speed) : self.speed(255)
      end

      def forward?
        @current_direction == :forward
      end

      def backward?
        (not forward?)
      end

      private
      def change_state(state)
        @current_state = state
        if state == Firmata::PinLevels::HIGH
          direction(@current_direction)
        elsif state == Firmata::PinLevels::LOW
          connection.digital_write(@forward_pin, state)
          connection.digital_write(@backward_pin, state)
        end
      end

      def direction(direction)
        @current_direction = direction
        case direction
        when :forward
          forward_pin_level = Firmata::PinLevels::HIGH
          backward_pin_level = Firmata::PinLevels::LOW
        when :backward
          forward_pin_level = Firmata::PinLevels::LOW
          backward_pin_level = Firmata::PinLevels::HIGH
        end
        connection.set_pin_mode(@forward_pin, Firmata::PinModes::OUTPUT)
        connection.digital_write(@forward_pin, forward_pin_level)
        connection.set_pin_mode(@backward_pin, Firmata::PinModes::OUTPUT)
        connection.digital_write(@backward_pin, backward_pin_level)
      end

    end

    module BidirectionalWith4Pins

    end

  end
end
