require 'artoo'

# Circuit and schematic here: http://arduino.cc/en/tutorial/button

#connection :firmata, :adaptor => :firmata, :port => '/dev/tty*'
connection :firmata, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :led, :driver => :device_info, :pin => 13
device :button, :driver => :button, :pin => 2, :interval => 0.01

work do
  puts
  puts "Press the button connected on pin #{button.pin}..."

  on button, :push => proc {
    if led.on?
      led.off
    else
      led.on
    end
  }
end
