require 'artoo/drivers/driver'

module Artoo
  module Drivers
    # Board driver behaviors
    class Board < Driver
      COMMANDS = [:firmware_name, :version, :connect].freeze
    end
  end
end
