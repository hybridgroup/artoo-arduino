require 'artoo'

# For LED brightness:
# Circuit and schematic here: http://arduino.cc/en/Tutorial/Fade
#
# For Analog Input:
# Substitute the button with an analog sensor like a photoresistor and 
# change to the correct analog input, in this case pin A0.
# Circuit and schematic here: http://arduino.cc/en/tutorial/button

connection :firmata, :adaptor => :firmata, :port => '/dev/ttyACM0' # linux
#connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :sensor, driver: :analog_sensor, pin: 0, interval: 0
device :led, :driver => :led, :pin => 3

ai_pin = 0

work do
  puts "Reading sensor in analog pin #{ sensor.pin }"
  puts "Reading analog sensor intervals every => #{ sensor.interval }"

  every(0.25) do
    analog_read = sensor.analog_read(ai_pin)
    brightness_val = analog_read.to_pwm_reverse
    puts "Analog Read => #{ analog_read }"
    puts "brightness val => #{ brightness_val }"
    led.brightness(brightness_val)
  end
end
