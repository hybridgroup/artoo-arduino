require 'lib/artoo/adaptors/firmata'
require 'lib/artoo/adaptors/littlewire'

%w{ button led motor servo wiichuck wiiclassic wiidriver }.each do |f|
  require "lib/artoo/drivers/#{f}")
end

require 'lib/artoo-arduino/version'
