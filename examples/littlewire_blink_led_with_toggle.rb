require 'artoo'

connection :digispark, :adaptor => :littlewire, :vendor => 0x1781, :product => 0x0c9f
device :board, :driver => :board
device :led, :driver => :led, :pin => 1

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmware version: #{board.version}"

  every 1.second do
    led.toggle
  end
end
