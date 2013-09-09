require 'artoo'

# Uses Digispark USB board (http://digistump.com/products/1) 
# and Digispark RGB shield (http://digistump.com/products/3)
# with Little Wire protocol (http://littlewire.cc)

connection :digispark, :adaptor => :littlewire, :vendor => 0x1781, :product => 0x0c9f
device :board, :driver => :board
device :red_led, :driver => :led, :pin => 0
device :green_led, :driver => :led, :pin => 1
device :blue_led, :driver => :led, :pin => 2

work do
  puts "Firmware name: #{board.firmware_name}"
  puts "Firmware version: #{board.version}"

  @count = 0

  every 1.second do
    case @count % 4
    when 0
      green
    when 1
      red
    when 2
      blue
    when 3
      off
    end
    @count += 1
  end

  def red
    red_led.on
    green_led.off
    blue_led.off
  end

  def green
    red_led.off
    green_led.on
    blue_led.off
  end

  def blue
    red_led.off
    green_led.off
    blue_led.on
  end

  def off
    red_led.off
    green_led.off
    blue_led.off
  end
end
