require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/Tutorial/Fade

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board
device :led, :driver => :led, :pin => 3

brightness = 0
fade_amount = 5


work do

  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  led.on

  every(0.05) do
    led.brightness(brightness)
    brightness = brightness + fade_amount
    if brightness == 0 or brightness == 255
      fade_amount = -fade_amount
    end
  end

end
