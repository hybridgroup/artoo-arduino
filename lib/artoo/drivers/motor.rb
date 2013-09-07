require 'artoo/drivers/driver'

module Artoo
  module Drivers
    class Motor < Driver

      COMMANDS = [:stop, :start, :on?, :off?, :toggle, :speed, :min, :max, :forward, :backward, :current_speed].freeze

      attr_reader :speed_pin, :switch_pin, :current_speed

      def initialize(params={})
        super
        
        additional_params = params[:additional_params]
        @speed_pin = additional_params[:speed_pin]
        @switch_pin = additional_params[:switch_pin] if additional_params[:switch_pin]

        @forward_pin = additional_params[:forward_pin]
        @backward_pin = additional_params[:backward_pin]

        @current_state = :low
        @current_speed = 0

        # digital: just to switch the motor on or off, no speed control
        # analog: speed control
        @current_mode = :digital

        @current_direction = :forward

        @@modules_to_include = modules_to_include

        class << self
          @@modules_to_include.each do |m|
            include m
          end if @@modules_to_include
        end

      end

      def digital?
        @current_mode == :digital
      end
      
      def analog?
        @current_mode == :analog
      end

      def stop
        if digital?
          change_state(:low)
        else
          speed(0)
        end
      end

      def start
        if digital?
          change_state(:high)
        else
          speed(@current_speed.zero? ? 255 : @current_speed)
        end
      end

      def min
        stop
      end

      def max
        speed(255)
      end

      def on?
        if digital?
          @current_state == :high
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
        @current_speed = state == :low ? 0 : 255
        connection.digital_write(@speed_pin, state)
      end

      # Set motor speed
      # @param [Integer] value (must be an integer between 0-255)
      def speed(value)
        @current_mode = :analog
        raise "Motor speed must be an integer between 0-255" unless (value.is_a?(Numeric) && value >= 0 && value <= 255)
        @current_speed = value
        connection.pwm_write(speed_pin, value)
      end

      private
      def modules_to_include
        if @forward_pin and @backward_pin
          [BidirectionalWithForwardBackwardPins]
        end
      end
    end

    module BidirectionalWithForwardBackwardPins

      # Sets movement forward
      # @param [Integer] speed
      def forward(speed = nil)
        direction(:forward)
        speed ? self.speed(speed) : start
      end

      # Sets movement backward
      # @param [Integer] speed
      def backward(speed = nil)
        direction(:backward)
        speed ? self.speed(speed) : start
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
        @current_speed = state.zero? ? 0 : 255
        if state == :high
          direction(@current_direction)
          speed(@current_speed) if speed_pin
        elsif state == :low
          direction(:none)
        end
      end

      def direction(direction)
        @current_direction = direction
        case direction
        when :forward
          forward_pin_level = :high
          backward_pin_level = :low
        when :backward
          forward_pin_level = :low
          backward_pin_level = :high
        when :none
          forward_pin_level = :low
          backward_pin_level = :low
        end
        
        connection.digital_write(@forward_pin, forward_pin_level)
        connection.digital_write(@backward_pin, backward_pin_level)
      end

    end
  end
end
