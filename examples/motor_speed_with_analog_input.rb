require 'artoo'
# For motor speed output:
# Circuit's breadboard layout here: http://learn.adafruit.com/adafruit-arduino-lesson-13-dc-motors/breadboard-layout
#
# For the analog input:
# Substitute the button with an analog sensor like a photoresistor and 
# change to the correct analog input, in this case pin A0.
# Circuit and schematic here: http://arduino.cc/en/tutorial/button

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
#device :board, :driver => :device_info
device :sensor, driver: :analog_sensor, pin: 0, interval: 0
device :motor, :driver => :motor, :speed_pin => 3 # Use a PWM pin

ai_pin = 0

work do

  puts "Reading sensor in analog pin #{ sensor.pin }"
  puts "Reading intervals every => #{ sensor.interval }"

  every(0.25) do
    analog_read = sensor.analog_read(ai_pin)
    motor_speed = ((255.0 / 1023.0) * (analog_read.to_f)).round
    puts "Analog Read => #{ analog_read }"
    puts "Motor Speed => #{ motor_speed }"
    motor.speed(motor_speed)
  end

end 
