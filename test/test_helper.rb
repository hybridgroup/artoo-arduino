require 'minitest'
require 'minitest/autorun'
require 'mocha/setup'
require 'firmata'
require 'artoo/robot'
require 'artoo-arduino'

Celluloid.logger = nil

MiniTest::Spec.before do
  Celluloid.shutdown
  Celluloid.boot
end
