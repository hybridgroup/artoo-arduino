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
    it "#firmware_name"
    it "#version"
  end

  describe "digital GPIO interface" do
    it "#digital_read"
    it "#digital_write"
  end

  describe "analog GPIO interface" do
    it "#analog_read"
    it "#analog_write"
  end

  describe "PWM GPIO interface" do
    it "#pwm_write"
  end

  describe "servo GPIO interface" do
    it "#servo_write"
  end

  describe "i2c interface" do
    it "#i2c_start"
    it "#i2c_end"
    it "#i2c_read"
    it "#i2c_write"
  end
end
