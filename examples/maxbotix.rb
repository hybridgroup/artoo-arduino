require 'artoo'

# Circuit and schematic here: http://www.electrojoystick.com/tutorial/?page_id=285

#connection :firmata, :adaptor => :firmata, :port => '/dev/ttyACM0'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:4567'
device :sonar, :driver => :maxbotix, :pin => 0, :interval => 0.5
device :board, :driver => :device_info

work do
  on sonar, :range => :sonar_reading

  puts "Firmware name: #{board.firmware_name}"
  puts "Firmata version: #{board.version}"
  puts "starting sonar..."
end

def sonar_reading(*args)
  puts args
end
