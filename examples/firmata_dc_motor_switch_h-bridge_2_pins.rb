require 'artoo'

#Circuit's breadboard layout here (L239): http://www.electrojoystick.com/tutorial/?p=759
# for the L239DNE: breadboard layout for the L239DNE: http://bit.ly/14QdjD5

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board
device :motor, :driver => :motor, :forward_pin => 2, :backward_pin => 3

work do
  board.connect
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  puts
  puts "Stopping motor..."
  motor.stop
  sleep 2

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
