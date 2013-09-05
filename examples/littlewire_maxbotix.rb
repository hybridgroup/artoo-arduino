require 'artoo'

# Circuit and schematic here: http://www.electrojoystick.com/tutorial/?page_id=285

connection :digispark, :adaptor => :littlewire, :vendor => 0x1781, :product => 0x0c9f
device :sonar, :driver => :maxbotix, :pin => 0, :interval => 0.5
device :board, :driver => :board

work do
  on sonar, :range => :sonar_reading

  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"
  puts "starting sonar..."
end

def sonar_reading(*args)
  puts args[1] * 1000
end
