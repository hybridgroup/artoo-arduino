require 'artoo'

# Substitute the button with an analog sensor like a photoresistor and 
# change to the correct analog input, in this case pin A0.
# Circuit and schematic here: http://arduino.cc/en/tutorial/button

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'

# Analog inputs are based from 0 to 5 on the Arduino UNO, may vary on other arduino boards
device :sensor, driver: :analog_sensor, pin: 0, interval: 0.25, upper: 900, lower: 200
device :led, :driver => :led, :pin => 8

work do
  puts
  puts "Reading sensor in analog pin #{ sensor.pin }"
  puts "Reading intervals every => #{ sensor.interval }"
  puts "Initial sensor value => #{ sensor.analog_read(0) }"
  puts "Sensor upper trigger set at value => #{ sensor.upper }"
  puts "Sensor lower trigger set at value => #{ sensor.lower }"

  on sensor, :upper => proc {
    puts "UPPER LIMIT REACHED!"
    led.off
  }

  on sensor, :lower => proc {
    puts "LOWER SENSOR LIMIT REACHED!"
    led.on
  }
end
