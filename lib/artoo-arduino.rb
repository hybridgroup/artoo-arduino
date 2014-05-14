require 'artoo/adaptors/firmata'

%w{ button led motor servo wiichuck wiiclassic wiidriver }.each do |f|
  require "artoo/drivers/#{f}"
end

require 'artoo-arduino/version'
