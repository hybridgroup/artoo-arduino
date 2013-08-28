require 'artoo'

#Circuit's breadboard layout here: http://learn.adafruit.com/adafruit-arduino-lesson-13-dc-motors/breadboard-layout

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board, :driver => :firmata_board
device :motor, :driver => :motor, :pin => [nil, nil, 3] # Needs a PWM pin

work do
  board.connect
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  motor.stop
  speed = 0
  step = 50

  every 4.seconds do
    puts "Current speed: #{speed}"
    motor.speed speed
    speed += step
    if [0, 250].include?(speed)
      step = -step
    end
  end
end

