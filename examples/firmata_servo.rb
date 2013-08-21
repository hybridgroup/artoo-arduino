require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/Tutorial/Sweep

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board
device :servo, :driver => :servo, :pin => 3 # pin must be a PWM pin

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  every(2) do
    case servo.current_angle
    when 90 then servo.max
    when 0 then servo.center
    when 180 then servo.min
    end
  end
end
