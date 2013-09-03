require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Board driver behaviors for Firmata
    class FirmataBoard < Driver
      COMMANDS = [:firmware_name, :version, :connect].freeze
    end
  end
end
