require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/Tutorial/Blink

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board, :driver => :device_info
device :led, :driver => :led, :pin => 13

work do
  puts "Firmware name: #{board.name}"
  puts "Firmware version: #{board.version}"

  every 1.second do
    led.toggle
  end
end

