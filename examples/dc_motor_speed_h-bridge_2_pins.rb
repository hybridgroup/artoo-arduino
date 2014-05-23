require 'artoo'

#Circuit's breadboard layout for the L293D: http://www.electrojoystick.com/tutorial/?p=759
#For the L239DNE: http://bit.ly/14QdjD5

connection :firmata, :adaptor => :firmata, :port => '/dev/ttyACM0' # linux
#connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board, :driver => :device_info
device :motor, :driver => :motor, 
               :forward_pin  => 4, # Digital or PWM pin
               :backward_pin => 2, # Digital or PWM pin
               :speed_pin    => 9  # PWM pin only

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"
  puts "Stopping motor..."
  motor.stop
  sleep 2

  loop do
    motor.forward # if no speed set, spins at max speed
    puts "Going forward, Speed: #{motor.current_speed}"
    sleep 3
    motor.forward 180
    puts "Going forward, Speed: #{motor.current_speed}"
    sleep 3
    puts "Stopping..."
    motor.stop
    sleep 2
    motor.backward(150) # spins at speed 150
    puts "Going backward, Speed: #{motor.current_speed}"
    sleep 3
    motor.backward(255)
    puts "Going backward, Speed: #{motor.current_speed}"
    sleep 3
  end
end
