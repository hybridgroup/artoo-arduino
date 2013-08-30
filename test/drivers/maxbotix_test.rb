require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/maxbotix'

describe Artoo::Drivers::Maxbotix do
  before do
    @device = mock('device')
    @pin = 0
    @device.stubs(:pin).returns(@pin)
    @maxbotix = Artoo::Drivers::Maxbotix.new(:parent => @device)
    @connection = mock('connection')
    @device.stubs(:connection).returns(@connection)
  end

  describe '#range' do
    it 'must have initial value' do
      @maxbotix.range.must_equal 0.0
    end

    it 'must adjust based on last_reading' do
      @maxbotix.last_reading = 13.5
      @maxbotix.range.must_equal 6.697265625
      @maxbotix.range_cm.must_equal 17.145
    end
  end
end
