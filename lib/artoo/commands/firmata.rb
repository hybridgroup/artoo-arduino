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
        hex_path = File.join(File.expand_path(File.dirname(__FILE__)), "hex/StandardFirmata.cpp.hex")
        hex_file = "-Uflash:w:#{ hex_path }:i"
        port = "-P#{ options[:serial_port] }"
        case os
        when :linux
          run("avrdude #{ part } #{ programmer } #{ port } #{ baudrate } -D #{ hex_file }")
        when :macosx
          run("avrdude #{ part } #{ programmer } #{ port } #{ baudrate } -D #{ hex_file }")
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
