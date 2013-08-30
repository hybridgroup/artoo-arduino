require 'artoo'

# Circuit and schematic here: http://www.electrojoystick.com/tutorial/?page_id=285

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :sonar, :driver => :maxbotix, :pin => 0, :interval => 1

work do
  on sonar, :range => :sonar_reading
end

def sonar_reading(*args)
  puts args
end
