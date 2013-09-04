require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/led'

describe Artoo::Drivers::Led do
  before do
    @device = mock('device')
    @pin = 13
    @device.stubs(:pin).returns(@pin)
    @led = Artoo::Drivers::Led.new(:parent => @device)
    @connection = mock('connection')
    @device.stubs(:connection).returns(@connection)
  end

  describe 'state switching' do
    describe '#on' do
      it 'must turn the led on' do
        @connection.expects(:digital_write).with(@pin, :high)
        @led.on
      end
    end

    describe '#off' do
      it 'must turn the led off' do
        @connection.expects(:digital_write).with(@pin, :low)
        @led.off
      end
    end
  end

  describe 'state checking' do

    before do
      @led.stubs(:change_state)
    end

    describe '#on?' do
      it 'must return true if led is on' do
        @led.on
        @led.on?.must_equal true
      end

      it 'must return false if led is off' do
        @led.off
        @led.on?.must_equal false
      end
    end

    describe '#off?' do
      it 'must return true if led is off' do
        @led.off
        @led.off?.must_equal true
      end

      it 'must return false if led is on' do
        @led.on
        @led.off?.must_equal false
      end
    end
  end

  describe '#toggle' do
    it 'must toggle the state of the led' do
      @led.stubs(:pin_state_on_board).returns(false)
      @connection.stubs(:set_pin_mode)
      @connection.stubs(:digital_write)
      @led.off?.must_equal true
      @led.toggle
      @led.on?.must_equal true
      @led.toggle
      @led.off?.must_equal true
    end
  end

  describe '#brightness' do
    it 'must change the brightness of the led' do
      val = 100
      @connection.expects(:pwm_write).with(@pin, val)
      @led.brightness(val)
    end
  end

  describe '#commands' do
    it 'must contain all the necessary commands' do
      @led.commands.must_include :on
      @led.commands.must_include :off
      @led.commands.must_include :toggle
      @led.commands.must_include :brightness
      @led.commands.must_include :on?
      @led.commands.must_include :off?
    end
  end
end
