require 'artoo'

#Circuit's breadboard layout here: http://learn.adafruit.com/adafruit-arduino-lesson-13-dc-motors/breadboard-layout

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board
device :motor, :driver => :motor, :switch_pin => 3 # Use a digital or PWM pin

work do
  board.connect
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  puts
  puts "Stopping motor..." #just in case
  motor.stop
  sleep 3

  every 3.seconds do
    motor.toggle
    puts "Motor is #{motor.on? ? 'on' : 'off'}"
  end

end
