require 'artoo'

#Circuit's breadboard layout here (L239): http://www.electrojoystick.com/tutorial/?p=759
# for the L239DNE: breadboard layout for the L239DNE: http://bit.ly/14QdjD5

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board
device :motor, :driver => :motor, 
               :forward_pin  => 0, # Digital or PWM pin
               :backward_pin => 1, # Digital or PWM pin
               :speed_pin    => 3  # PWM pin only

work do
  board.connect
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  puts
  puts "Stopping motor..."
  motor.stop
  sleep 2
  #motor.speed(150) # Set initial speed

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
