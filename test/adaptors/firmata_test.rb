require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/firmata'
require 'firmata'

describe Artoo::Adaptors::Firmata do
  before do
    @port = Artoo::Port.new('/dev/awesome')
    @adaptor = Artoo::Adaptors::Firmata.new(:port => @port)
    @firmata = mock('firmata')
    Firmata::Board.stubs(:new).returns(@firmata)
  end

  it 'Artoo::Adaptors::Firmata#connect' do
    @firmata.expects(:connect)
    @adaptor.connect.must_equal true
  end

  it 'Artoo::Adaptors::Firmata#disconnect' do
    @firmata.stubs(:connect)
    @adaptor.connect
    @adaptor.disconnect

    @adaptor.connected?.must_equal false
  end

  describe "device info interface" do

    it "expects #firmware_name to return Firmata firmware name" do
     @firmata.expects(:firmware_name).returns("StandardFirmata.ino")
     @adaptor.stubs(:firmata).returns(@firmata)
     @adaptor.firmware_name.must_equal "StandardFirmata.ino"
    end

    it "expects #version to return Firmata version" do
     @firmata.expects(:version).returns("2.3")
     @adaptor.stubs(:firmata).returns(@firmata)
     @adaptor.version.must_equal "2.3"
    end

  end

  describe "digital/analog I/O" do
    before do
       @firmata.stubs(:set_pin_mode)
       @firmata.stubs(:toggle_pin_reporting)
       @firmata_event = mock('event')
       @firmata_event.stubs(:data).returns([1])
       @firmata.stubs(:async_events).returns([@firmata_event])
       @adaptor.stubs(:firmata).returns(@firmata)
    end

    describe "digital GPIO interface" do
      it "#digital_read" do
       @firmata_event.stubs(:name).returns(:digital_read_1)
       @firmata.expects(:read_and_process)
       @adaptor.digital_read(1).must_equal 1
      end

      it "#digital_write" do
        @firmata.expects(:digital_write).returns(true)
        @adaptor.digital_write(13, 1).must_equal true
      end
    end

    describe "analog GPIO interface" do
      it "#analog_read" do
       @firmata_event.stubs(:name).returns(:analog_read_1)
       @firmata_event.stubs(:data).returns([128])
       @firmata.stubs(:analog_pins).returns([0,1])
       @firmata.expects(:read_and_process)
       @adaptor.analog_read(1).must_equal 128
      end
    end
  end

  describe "Analog output" do
    before do
      @firmata.stubs(:set_pin_mode)
      @firmata.expects(:analog_write).returns(true)
      @adaptor.stubs(:firmata).returns(@firmata)
    end

    describe "PWM GPIO interface" do
      it "#pwm_write" do
        @adaptor.pwm_write(3, 128).must_equal true
      end
    end

    describe "servo GPIO interface" do
      it "#servo_write" do
        @adaptor.servo_write(3, 128).must_equal true
      end
    end
  end

  describe "i2c interface" do
    before do
      @adaptor.stubs(:firmata).returns(@firmata)
    end
    it "#i2c_start" do
      @firmata.expects(:i2c_config).returns(true)
      @adaptor.i2c_start(0).must_equal(true)
    end

    it "#i2c_end" do

    end

    it "#i2c_read" do
      @firmata.expects(:i2c_read_request)
      @firmata.expects(:read_and_process)
      @firmata_event = mock('event')
      @firmata_event.stubs(:data).returns([{ data: 1 }])
      @firmata_event.stubs(:name).returns(:i2c_reply)
      @firmata.stubs(:async_events).returns([@firmata_event])
      @adaptor.i2c_read(1).must_equal(1)
    end

    it "#i2c_write" do
      @firmata.expects(:i2c_write_request).returns(true)
      @adaptor.i2c_write([1, 8]).must_equal(true)
    end
  end
end
