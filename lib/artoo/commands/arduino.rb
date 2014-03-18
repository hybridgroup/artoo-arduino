require './firmata'

module Artoo
  module Commands
    class Arduino < Firmata
      package_name "arduino"
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
    desc "arduino SUBCOMMAND <serial_port>", "Installs avrdude, uploads firmata to the arduino and connects serial to socket"
    subcommand "arduino", Artoo::Commands::Arduino
  end
end
