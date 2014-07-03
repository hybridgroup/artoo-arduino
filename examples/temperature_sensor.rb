require 'artoo'

connection :firmata, :adaptor => :firmata, :port => '/dev/cu.usbmodem1451'

# TMP36 temperature sensor used for this example
device :sensor, driver: :analog_sensor, pin: 0

work do
  every 5 do
    voltage = ( sensor.analog_read(0) * 5.0 ) / 1024
    temp    = ( voltage - 0.5 ) * 100

    puts "Current temperature is #{temp}"
  end
end
