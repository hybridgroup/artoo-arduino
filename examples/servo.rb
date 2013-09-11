require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/Tutorial/Sweep

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board, :driver => :device_info
device :servo, :driver => :servo, :pin => 3 # pin must be a PWM pin

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  servo.move(0) # reset the position of the sweep (same as servo.min)

  every(2) do
    case servo.current_angle
    when 0 then servo.center
    when 90 then servo.max
    when 180 then servo.min
    end
  end
end
