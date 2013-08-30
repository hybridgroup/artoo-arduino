require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/Tutorial/Blink

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:4567'
device :board, :driver => :firmata_board
device :led, :driver => :led, :pin => 13

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"

  every 1.second do
    led.on? ? led.off : led.on
  end
end
