require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/tutorial/button

connection :digispark, :adaptor => :littlewire, :vendor => 0x1781, :product => 0x0c9f
device :board, :driver => :board
device :led, :driver => :led, :pin => 1
device :button, :driver => :button, :pin => 0, :interval => 0.01

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmware version: #{board.version}"
  puts "Press the button connected on pin #{button.pin}..."

  on button, :push    => proc { led.toggle }
end
