require 'artoo'

leg1_pin = 7  # digital pin
leg2_pin = 4  # digital pin
speed_pin = 3 # PWM pin

speed = 0
forward = true

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board, :driver => :firmata_board
device :motor, :driver => :motor, :pin => [leg1_pin, leg2_pin, speed_pin]

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  every(0.1)do
    forward ? motor.forward(speed) : motor.backward(speed)
    speed += 10
    if speed >= 255
      speed = 0
      forward = (not forward)
      sleep 1 # give the motor some time to stop inertia
    end
  end
end
