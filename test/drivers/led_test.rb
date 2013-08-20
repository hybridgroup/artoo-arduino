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

  #describe '#pin_state_board' do

    #let(:pins) { mock('pins') }
    #let(:pin)  { mock('pin', value: 1) }

    #before do
      #@connection.stubs(:pins).returns(pins)
    #end

    #it 'must retrive the actual state of the led in the board' do
      #@connection.stubs(:async_events).returns([mock('event', name: 'pin_1_state', data: [1])])
      #@connection.expects(:query_pin_state_on_board)
      #@connection.expects(:handle_pin_state_event)
      #@led.start_driver
      #@led.on?.must_equal true
    #end
  #end

  describe '#change_state' do

    before do
      @connection.expects(:set_pin_mode).with(@pin, Firmata::PinModes::OUTPUT)
    end

    it 'must set the mode to OUTPUT and write the level HIGH' do
      @connection.expects(:digital_write).with(@pin, Firmata::PinLevels::HIGH)
      @led.on
    end

    it 'must set the mode to OUTPUT and write the level HIGH' do
      @connection.expects(:digital_write).with(@pin, Firmata::PinLevels::LOW)
      @led.off
    end
  end

  describe 'when pin state is read from board' do

    before do
      @connection.expects(:query_pin_state).with(13)
    end

    describe '#on? and #off? when led is on' do
      it 'must return correct state when led is on' do
        event_pin_13 = mock('event', name: :pin_13_state, data: [1])
        @connection.stubs(:async_events).returns([event_pin_13])
        @led.start_driver
        @led.on?.must_equal true
        @led.off?.must_equal false
      end

      it 'must return correct state when led is off' do
        event_pin_13 = mock('event', name: :pin_13_state, data: [0])
        @connection.stubs(:async_events).returns([event_pin_13])
        @led.start_driver
        @led.on?.must_equal false
        @led.off?.must_equal true
      end
    end

  end

  describe 'when pin state is already initialized' do

    before do
      @led.stubs(:change_state)
    end

    describe '#on? and #off?' do
      it 'must return correct state when led is on' do
        @led.on
        @led.on?.must_equal true
        @led.off?.must_equal false
      end

      it 'must return correct state when led is on' do
        @led.off
        @led.on?.must_equal false
        @led.off?.must_equal true
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
      @connection.expects(:set_pin_mode).with(@pin, Firmata::PinModes::PWM)
      @connection.expects(:analog_write).with(@pin, val)
      @led.brightness(val)
    end
  end

  describe '#commands' do
    it 'must contain all the necessary commands' do
      @led.commands.must_include :firmware_name
      @led.commands.must_include :version
      @led.commands.must_include :on
      @led.commands.must_include :off
      @led.commands.must_include :toggle
      @led.commands.must_include :brightness
      @led.commands.must_include :on?
      @led.commands.must_include :off?
    end
  end
end
