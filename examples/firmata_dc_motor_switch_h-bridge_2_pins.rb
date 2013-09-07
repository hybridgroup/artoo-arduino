require 'artoo'

#Circuit's breadboard layout for the L293D here: http://www.electrojoystick.com/tutorial/?p=759
#For the L239DNE: http://bit.ly/14QdjD5,
#   L293DNE's pin 1 should go to 5V instead of to Arduino's pin 9

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board, :driver => :board
device :motor, :driver => :motor, :forward_pin => 4, :backward_pin => 2

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"
  puts "Stopping motor..."
  motor.stop
  sleep 1

  loop do
    puts "Going forward..."
    motor.forward
    sleep 3
    puts "Stopping..."
    motor.stop
    sleep 2
    puts "Going backward..."
    motor.backward
    sleep 3
  end

end
