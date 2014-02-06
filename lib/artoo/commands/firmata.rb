require 'artoo/commands/commands'

module Artoo
  module Commands
    class Firmata < Commands
      package_name "firmata"

      desc "upload", "Uploads firmata to the arduino using avrdude"
      option :serial_port, aliases: '-p', default: "/dev/ttyACM0", desc: "serial port address e.g. /dev/ttyACM0"
      def upload
        part = '-patmega328p'
        programmer = '-carduino'
        baudrate = '-b115200'
        hexPath = File.join(File.expand_path(File.dirname(__FILE__)), "hex/StandardFirmata.cpp.hex")
        hexFile = "-Uflash:w:#{ hexPath }:i"
        case os
        when :linux
          port = "-P#{ options[:serial_port] }"
          run("avrdude #{ part } #{ programmer } #{ port } #{ baudrate } -D #{ hexFile }")
        when :macosx
          port = "-P#{ options[:serial_port] }"
          run("avrdude #{ part } #{ programmer } #{ port } #{ baudrate } -D #{ hexFile }")
        else
          say "OS not yet supported..."
        end
      end

      desc "install", "Install avrdude in order to be able to upload firmata to the arduino"
      def install
        case os
        when :linux
          run('sudo apt-get install avrdude')
        when :macosx
          Bundler.with_clean_env do
            run("brew install avrdude")
          end
        else
          say "OS not yet supported..."
        end
      end
    end
  end
end
