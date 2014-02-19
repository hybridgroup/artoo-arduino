require 'artoo/commands/commands'

module Artoo
  module Commands
    class Firmata < Commands
      package_name "firmata"

      desc "upload [ADDRESS]", "Uploads firmata to the arduino using avrdude"
      def upload(address)
        part = '-patmega328p'
        programmer = '-carduino'
        baudrate = '-b115200'
        hex_path = File.join(File.expand_path(File.dirname(__FILE__)), "StandardFirmata.cpp.hex")
        hex_file = "-Uflash:w:#{ hex_path }:i"
        port = (address[/[\/\:]/].nil?) ? "-P/dev/#{ address }" : "-P#{ address }"
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

# We need to register the commands in the main artoo CLI so they
# can be picked up when this command file is required.
# The steps needed to register new CLI commands from outside
# artoo are:
# 1. Related command files need to be copied to the artoo install commands.
# 2. We do this with a rake task that is triggered when the gem is installed
#    (see .gemspec file and look for extensions, ext/Rakefile), in the Rakefile
#    we defined a new default class that makes use of an artoo helper class/method
#    Artoo::Commands::Install helper method '.command'; see ext/Rakefile for details.
# 3. Finally in our main command file (THIS FILE) we open the artoo CLI::Root class to register
#    the new commands.
module CLI
  class Root
    desc "firmata SUBCOMMAND <serial_port>", "Installs avrdude and uploads firmata to the arduino"
    subcommand "firmata", Artoo::Commands::Firmata
  end
end
