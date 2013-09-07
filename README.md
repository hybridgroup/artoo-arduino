# Artoo Adaptor For Arduino

This repository contains the Artoo (http://artoo.io/) adaptor and drivers for Arduino and Arduino-compatible microcontrollers (http://arduino.cc/) using either the Firmata protocol (http://firmata.org) or the Little Wire protocol (http://littlewire.cc).

Artoo is a open source micro-framework for robotics using Ruby.

For more information abut Artoo, check out our repo at https://github.com/hybridgroup/artoo

[![Code Climate](https://codeclimate.com/github/hybridgroup/artoo-arduino.png)](https://codeclimate.com/github/hybridgroup/artoo-arduino) [![Build Status](https://travis-ci.org/hybridgroup/artoo-arduino.png?branch=master)](https://travis-ci.org/hybridgroup/artoo-arduino)

This gem makes extensive use of the hybridgroup fork of the firmata gem (https://github.com/hybridgroup/firmata) thanks to [@hardbap](https://github.com/hardbap) with code borrrowed from the arduino_firmata gem (https://github.com/shokai/arduino_firmata) thanks to [@shokai](https://github.com/shokai)

It also makes extensive use of the littlewire.rb gem (https://github.com/Bluebie/littlewire.rb) thanks to [@Bluebie](https://github.com/Bluebie)

## Installing

```
gem install artoo-arduino
```

## Using

```ruby
require 'artoo'

connection :arduino, :adaptor => :firmata, :port => '127.0.0.1:8023'
device :board
device :led, :driver => :led, :pin => 13

work do
  puts "Firmware name #{board.firmware_name}"
  puts "Firmata version #{board.version}"
  every 1.second do
    led.toggle
  end
end
```

## Devices supported

The following hardware devices have driver support:
- Button
- LED
- Maxbotix ultrasonic range finder
- Motor (DC)
- Servo
- Wiichuck controller (via i2c)
- Wiiclassic controller (via i2c)

## Connecting to Arduino

### OSX

The main steps are:
- Connect to the Arduino via serial port/USB
- Use a socket to serial connection to map a TCP socket to the local unix port
- Connect to the device via Artoo

First plug the Arduino into your computer via the USB/serial port. A dialog box will appear telling you that a new network interface has been detected. Click "Network Preferences...", and when it opens, simply click "Apply".

Once plugged in, use the `artoo connect scan` command to find out your connection info:

```
$ artoo connect scan
```

Now you are ready to connect to the Arduino using a socket, such as in this example port 4567:

```
artoo connect serial ttyACM0
```

### Ubuntu

The main steps are:
- Connect to the Arduino via serial port/USB
- Use a socket to serial connection to map a TCP socket to the local unix port
- Connect to the device via Artoo

First plug the Arduino into your computer via the USB/serial port.

Once plugged in, use the `ls /dev/ttyACM*` command to find out your connection info:

```
$ ls /dev/ttyACM*
/dev/ttyACM0
```

Now you are ready to connect to the Arduino using the socket, in this example port 4567:

```
artoo connect serial ttyACM0 4567
```

### Windows

Someone please fill in the blanks here...

## Connecting to Digispark

You can use Artoo with a Digispark (http://www.kickstarter.com/projects/digistump/digispark-the-tiny-arduino-enabled-usb-dev-board) ATTiny-based USB development board, that has the Little Wire (http://littlewire.cc/) protocol firmware installed. For instructions on how to install Little Wire on a Digispark check out http://digistump.com/board/index.php/topic,160.0.html

### OSX

The main steps are:
- Plug in the Digispark to the USB port
- Connect to the device via Artoo

First plug the Digispark into your computer via the USB port. Then... (directions go here)

### Ubuntu

The main steps are:
- Add a udev rule to allow access to the Digispark device
- Plug in the Digispark to the USB port
- Connect to the device via Artoo

First, you must add a udev rule, so that Artoo can communicate with the USB device. Ubuntu and other modern Linux distibutions use udev to manage device files when USB devices are added and removed. By default, udev will create a device with read-only permission which will not allow to you download code. You must place the udev rules below into a file named /etc/udev/rules.d/49-micronucleus.rules.

```
# UDEV Rules for Micronucleus boards including the Digispark.
# This file must be placed at:
#
# /etc/udev/rules.d/49-micronucleus.rules    (preferred location)
#   or
# /lib/udev/rules.d/49-micronucleus.rules    (req'd on some broken systems)
#
# After this file is copied, physically unplug and reconnect the board.
#
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1781", ATTRS{idProduct}=="0c9f", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="1781", ATTRS{idProduct}=="0c9f", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1"
#
# If you share your linux system with other users, or just don't like the
# idea of write permission for everybody, you can replace MODE:="0666" with
# OWNER:="yourusername" to create the device owned by you, or with
# GROUP:="somegroupname" and mange access using standard unix groups.
```

Thanks to [@bluebie](https://github.com/Bluebie) for these instructions! (https://github.com/Bluebie/micronucleus-t85/wiki/Ubuntu-Linux)

Now plug the Digispark into your computer via the USB port.

Once plugged in, use the `artoo connect scan` command with the  `-t usb` option to verify your connection info:

```
$ artoo connect scan -t usb
```

Now use the `ID` info returned to find the `product` and `vendor` ID's for the connection info Digispark in your Artoo code.

### Windows

Someone please fill in the blanks here...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
