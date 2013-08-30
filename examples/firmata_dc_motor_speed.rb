require 'artoo'

#Circuit's breadboard layout here: http://learn.adafruit.com/adafruit-arduino-lesson-13-dc-motors/breadboard-layout

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:4567'
device :board, :driver => :firmata_board
device :motor, :driver => :motor, :speed_pin => 3 # Use a PWM pin

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"
  puts "Stopping motor..."
  motor.min # same as 'motor.stop' or 'motor.speed(0)'
  sleep 3
  puts "Setting to maximum speed..."
  motor.max # same as 'motor.start'
  sleep 3

  speed = 0
  step = 50

  every 3.seconds do
    motor.speed(speed)
    puts "Current speed: #{motor.current_speed}"
    speed += step
    if [0, 250].include?(speed)
      step = -step
    end
  end
end

