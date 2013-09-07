require 'artoo'

#Circuit's breadboard layout here: http://learn.adafruit.com/adafruit-arduino-lesson-13-dc-motors/breadboard-layout

connection :digispark, :adaptor => :littlewire, :vendor => 0x1781, :product => 0x0c9f
device :board, :driver => :board
device :motor, :driver => :motor, :speed_pin => 1 # Use a PWM pin

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

