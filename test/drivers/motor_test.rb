require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/motor'

describe Artoo::Drivers::Motor do

  let(:connection) { mock('connection') }

  before do
    @device = mock('device')
    connection.stubs(:pwm_write)
    connection.stubs(:digital_write)
    @device.stubs(:connection).returns(connection)
  end

  describe 'mode predicate methods' do

    let(:motor) { Artoo::Drivers::Motor.new(:parent => @device, :additional_params => {}) }

    it '#digital?' do
      motor.digital?.must_equal true #initial state
      motor.speed(1)
      motor.digital?.must_equal false
    end

    it '#analog?' do
      motor.analog?.must_equal false
      motor.speed(1)
      motor.analog?.must_equal true
    end

  end

  describe 'when unidirectional' do

    describe 'when switching states (digital)' do

      let(:motor) { Artoo::Drivers::Motor.new(:parent => @device, :additional_params => {switch_pin: 1}) }

      it '#start' do
        motor.start
        motor.on?.must_equal true
      end

      it '#stop' do
        motor.stop
        motor.off?.must_equal true
      end

      it '#max' do
        motor.expects(:speed).with(255)
        motor.max
      end

      it '#min' do
        motor.min
      end

      describe '#toggle' do
        it 'toggles to on when off' do
          motor.start
          motor.toggle
          motor.off?.must_equal true
        end

        it 'toggles to off when on' do
          motor.stop
          motor.toggle
          motor.on?.must_equal true
        end
      end
    end

    describe 'when changing speed (analog)' do

      let(:motor) { Artoo::Drivers::Motor.new(:parent => @device, :additional_params => {speed_pin: 3}) }

      it '#speed' do
        connection.expects(:pwm_write).with(3, 255)
        motor.speed(255)
      end

      it '#start' do
        motor.speed(0)
        motor.start
        motor.current_speed.must_equal 255
      end

      it '#stop' do
        motor.speed(255)
        motor.stop
        motor.current_speed.must_equal 0
      end

      it '#max' do
        motor.speed(0)
        motor.max
        motor.current_speed.must_equal 255
      end

      it '#min' do
        motor.speed(255)
        motor.min
        motor.current_speed.must_equal 0
      end

      it '#on?' do
        motor.speed(1)
        motor.on?.must_equal true
        motor.speed(0)
        motor.on?.must_equal false
      end

      it '#off?' do
        motor.speed(1)
        motor.off?.must_equal false
        motor.speed(0)
        motor.off?.must_equal true
      end
    end

  end

  describe 'bididirectional' do
    let(:motor) { Artoo::Drivers::Motor.new(:parent => @device, 
                                            :additional_params => 
                                                {:forward_pin  => 1, 
                                                 :backward_pin => 2}) }

    describe '#forward' do

      before do
        connection.expects(:digital_write).with(1, :high)
        connection.expects(:digital_write).with(2, :low)
      end

      describe 'when no parameter' do

        it '#forward' do
          motor.expects(:start)
          motor.forward
        end

      end

      describe 'when speed parameter' do

        it '#forward' do
          motor.expects(:speed).with(255)
          motor.forward(255)
        end

      end

    end

    describe '#backward' do

      before do
        connection.expects(:digital_write).with(1, :low)
        connection.expects(:digital_write).with(2, :high)
      end

      describe 'when no parameter' do

        it '#backward' do
          motor.expects(:start)
          motor.backward
        end

      end

      describe 'when speed parameter' do

        it '#backward' do
          motor.expects(:speed).with(255)
          motor.backward(255)
        end

      end

    end
  end


  #it 'Motor#speed must be valid' do
    #invalid_speed = lambda { @motor2 = Artoo::Drivers::Motor.new(:parent => @device, :additional_params => {}); @motor2.speed("ads") }
    #invalid_speed.must_raise RuntimeError
    #error = invalid_speed.call rescue $!
    #error.message.must_equal 'Motor speed must be an integer between 0-255'
  #end

  #it 'Motor#forward' do
    #@motor.expects(:set_legs)
    #@motor.forward(100)
    #@motor.current_speed.must_equal 100
  #end

  #it 'Motor#backward' do
    #@motor.expects(:set_legs)
    #@motor.backward(100)
    #@motor.current_speed.must_equal 100
  #end

end
